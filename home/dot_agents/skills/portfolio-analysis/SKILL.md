---
name: portfolio-analysis
description: >
  Interactive portfolio analysis, tax optimization, and rebalancing.
  Imports brokerage CSVs (any format), classifies holdings, runs gap analysis,
  and generates tax-aware action plans. Use when the user wants to analyze
  investments, optimize allocation, rebalance, or validate a proposed plan.
  Triggers on: brokerage exports, allocation targets, portfolio analysis,
  tax-efficient investing, rebalancing.
---

# Portfolio Analysis

Interactive portfolio analysis and optimization. Walk users from raw brokerage data to a prioritized, tax-aware action plan.

> **Scope:** This skill is designed for US-based investors. Tax rates, account types (401k, IRA, HSA, 529), and fund mappings assume the US tax system. It will not produce correct guidance for other countries' tax laws.

## Workflow Overview

1. **Intake** — Understand the user's goals, accounts, and situation
2. **Data collection** — Import and parse brokerage CSVs, supplementary files, and manual holdings
3. **Profile setup** — Tax rates, account types, target allocation, contribution info
4. **Analyze** — Classify holdings, run gap analysis, tax impact, contribution alignment
5. **Recommend** — Prioritized actions with tax costs and rationale
6. **Report** — Interactive discussion and/or markdown export

## Disclaimers in Output

Every analysis output must include a disclaimer. This is not optional.

- **Written reports:** Start the report with a disclaimer block:
  > *This analysis is for informational and educational purposes only. It is not investment, tax, or financial advice. Consult a qualified financial advisor before making investment decisions. Tax rates and fund data may not reflect current values — verify before acting.*
- **Interactive sessions:** Include the disclaimer verbally at the start of the analysis walkthrough and remind the user before presenting specific trade recommendations.
- **Report template:** The disclaimer must appear in the report header (see Step 6 template).

## Using ask_user

Use `ask_user` at every major workflow gate to give users structured choices. This is especially important for CoWork and Claude Code users where the interactive experience matters. Key checkpoints:

- **Intake**: goals, timeline, risk tolerance
- **Profile setup**: tax info, account classification confirmation, target allocation selection, cash treatment
- **Classification**: unclassified holdings
- **Analysis options**: which additional analyses to run
- **Report**: format preference

When a question has clear options, always prefer ask_user over free-text prompts. Combine related questions into a single ask_user call (up to 4 questions per call).

## Step 1: Intake

Use `ask_user` to gather the user's situation with structured options. Combine into 1-2 calls to avoid back-and-forth.

**First ask_user call:**

```
Question 1 — "What are you looking to do?"
  Header: "Goal"
  Options:
    - "Rebalance" — "Adjust existing portfolio to match target allocation"
    - "Tax optimization" — "Improve tax efficiency without changing targets"
    - "General checkup" — "See where things stand, identify issues"
    - "Validate my plan" — "I have proposed changes — tell me if they make sense"

Question 2 — "How many years until you need this money?"
  Header: "Timeline"
  Options:
    - "0-5 years" — "Near-term need, capital preservation matters"
    - "5-10 years" — "Medium horizon, balanced approach"
    - "10-20 years" — "Long horizon, can ride out volatility"
    - "20+ years" — "Very long horizon, maximize growth"

Question 3 — "How comfortable are you with market drops?"
  Header: "Risk"
  Options:
    - "Very comfortable" — "40%+ drops are buying opportunities"
    - "Comfortable" — "20-30% drops are fine, I won't panic sell"
    - "Moderate" — "10-20% drops are okay, bigger ones stress me"
    - "Conservative" — "I prefer stability over growth"
```

**Then ask conversationally:**
- What brokerage accounts do you have?
- Any employer 401k or other accounts where you can't fully choose investments?

Defer tax details and target allocation to Step 3 — get data first so the conversation is grounded.

## Step 2: Data Collection

Guide the user to export and provide their brokerage CSVs.

### Export Instructions by Brokerage

**Before exporting:** Most brokerages let you customize which columns appear in the export. The more data you include, the better the analysis. Look for options to add: **cost basis**, **Morningstar category**, **Morningstar rating**, **expense ratio**, **load/fee information**, and **asset class or category**. The skill can often figure these out from the fund symbol, but having them in the export means fewer lookups and more accurate results.

**Fidelity:**
> Go to Positions → Download → select CSV. If you have multiple logins, export from each. Fidelity's default export includes Morningstar Category, which is especially helpful for classification.

**Schwab:**
> Go to Accounts → Positions → Export (top right).

**Vanguard:**
> Go to My Accounts → Holdings → Download to spreadsheet.

**E*TRADE / Other:**
> Look for a "Download" or "Export" option on your positions/holdings page.

### Supplementary Files

Users often provide more than just CSVs. Look for and handle:
- **Text/notes files** (.txt, .md) — may contain bank balances, 529 values, existing targets, proposed changes, or contribution schedules. Parse these for structured data.
- **Screenshots/images** (.png, .jpg) — Use the Read tool to view images. Common: 401k contribution breakdowns, account summaries, fund availability lists. Extract key data points.
- **Older CSV snapshots** — If the same account appears in multiple files at different dates, use the most recent data and note the discrepancy.

### How to Parse Brokerage CSVs

Do NOT use pre-built scripts. Instead, read each CSV's headers and write a small, targeted parser for the actual format found. This handles any brokerage — even ones never seen before.

#### Step-by-step parsing approach

1. **Read the file** with encoding fallback: try `utf-8-sig` first (handles BOM from Fidelity/Schwab), then `utf-8`, then `latin-1`
2. **Inspect the first 10-20 lines** — look at headers, spot footer disclaimers, identify the brokerage
3. **Write a targeted parser** (typically 15-30 lines of Python) that extracts holdings into normalized records

#### Brokerage detection heuristics

| Header patterns | Likely brokerage |
|---|---|
| "Account Number", "Morningstar Category" | Fidelity |
| "Account Number", "Current value", "Cost basis total" | Fidelity |
| "Symbol", "Mkt Val" or "Market Value" (no Account Number) | Schwab |
| "Fund Account Number", "Fund Name", "Shares" | Vanguard |
| "Account Type", "Last Price" | E*TRADE |
| "Security Description", "Account" | Merrill |
| Filename contains brokerage name | Use as tiebreaker |

#### Normalized holding fields to extract

Each parsed holding should have these fields:

```
account_id     — Account number / identifier
account_name   — Human-readable account name
symbol         — Ticker symbol (strip ** markers)
description    — Fund/security name
value          — Current market value (float)
cost_basis     — Total cost basis (float, 0 if unavailable)
gain           — Unrealized gain/loss (float, compute from value - cost_basis if not provided)
source         — Brokerage name (for provenance)
```

**Optional fields — extract these if present in the CSV:**

```
morningstar_category  — Fund category (e.g., "Large Blend", "Foreign Large Value")
morningstar_rating    — Star rating (1-5), useful for fund quality comparison
expense_ratio         — Annual expense ratio (float, e.g., 0.03 for 0.03%)
load                  — Front-end or back-end load percentage (float, 0 if no-load)
asset_class           — Brokerage-assigned asset class or category
```

These optional fields improve classification accuracy, fee analysis, and fund recommendations. When they're missing, the skill falls back to symbol lookup and the reference database, but having them in the export saves time and reduces guesswork.

#### Dollar value parsing

Strip `$`, `,`, `+` from value strings. Handle:
- Parenthetical negatives: `($500)` → `-500`
- Dashes: `--` → `0`
- Missing/blank: `N/A`, `n/a`, empty → `0`

#### Unknown or Zero Cost Basis

When cost basis shows as $0 or is missing, flag it — don't assume the entire position is gain. Common causes:
- **Gifted stock** — basis is the donor's original cost (often unknown in brokerage records)
- **Inherited stock** — basis is fair market value at date of death (stepped-up basis)
- **Old transfers** — basis wasn't transferred when moving between brokerages
- **Employee grants** — RSUs/options may show $0 basis

Present these to the user with `ask_user` and ask whether the $0 basis is real, unknown, or inherited. This materially affects tax impact calculations.

#### Deduplication

When multiple CSV exports overlap (common with Fidelity which requires separate logins):
- Deduplicate by `(account_id, symbol)` key
- If a duplicate exists, keep the record with the higher value (more recent)
- Report how many duplicates were removed

#### Common pitfalls to handle

- **Footer disclaimers**: Fidelity appends legal text as CSV rows — skip lines containing "brokerage services", "data and information", "date downloaded"
- **"Account Total" rows**: Schwab inserts summary rows — skip lines where Symbol = "Account Total"
- **"Pending activity" rows**: Fidelity shows pending — skip where symbol or description = "Pending activity"
- **Zero/negative values**: Skip holdings with value ≤ 0 (except cash which can be 0)
- **Schwab cash line**: "Cash & Cash Investments" appears as a symbol name, not a ticker — normalize to "CASH"
- **Header row detection**: Schwab CSVs sometimes start with comment rows before the actual header — scan for the row starting with "Symbol"

### Error Handling

- **Non-CSV files** (Excel, PDF, screenshots of holdings): Tell the user you need a CSV export specifically. If they provide an .xlsx, you can try reading it with Python (`openpyxl` or `pandas`), but CSV is preferred.
- **Empty or corrupt CSVs**: If parsing finds zero holdings, tell the user and ask them to re-export. Don't proceed with an empty dataset.
- **Unrecognized format**: If you can't identify any usable columns (no symbol, no value, no description), show the user the first few rows and ask them to help interpret the format.
- **Very small portfolios** (1-3 holdings): The analysis still works but skip gap analysis complexity — a simple "here's what you have, here's the target, here's the gap" is sufficient.
- **All cash or all bonds**: Flag that the portfolio is unusually concentrated in a single asset class and confirm that's intentional before proceeding.

### Manual Holdings

For holdings not in CSVs (bank cash, 529 plans, property, etc.), collect them conversationally and add to the holdings data. Common additions:
- Bank/savings account balances → classify as Cash
- 529 education savings → classify as Education (exclude from targets)
- I-Bonds or individual bonds → classify as Bonds
- Rental property equity → classify as Real Estate (optional — some prefer to exclude)

## Step 3: Profile Setup

Build a profile data structure with the user's information. This drives the analysis. Keep in memory or write to a file — whatever fits the workflow.

### Tax Information

Use `ask_user` to gather tax details. Ask filing status first, then tailor bracket options:

```
Question 1 — "What's your filing status?"
  Header: "Filing"
  Options:
    - "Married filing jointly"
    - "Single"
    - "Head of household"

Question 2 — "What state do you live in?"
  Header: "State"
  Options: Pick the 3-4 most common states, always include an "Other" option.
    Common high-population choices: California, Texas/Florida (no income tax), New York.
    Adjust if you have any context clues about the user's location.

Question 3 — "Approximate household income bracket?"
  Header: "Income"
  Options: Tailor to the filing status from Q1. For example, MFJ:
    - "$100K-$200K" — "22% federal marginal, 15% LTCG"
    - "$200K-$400K" — "24% federal marginal, 15% LTCG, NIIT may apply"
    - "$400K-$750K" — "32-35% federal marginal, 15-20% LTCG + NIIT"
    - "$750K+" — "37% federal marginal, 20% LTCG + NIIT"
  For Single, adjust the bracket thresholds accordingly.
```

**Tax data freshness:** The bracket thresholds in `references/tax-reference.md` reflect 2025 tax law and may be outdated. If the current year is 2027 or later, tell the user the reference data may be stale and encourage verifying current rates (or use a web search to confirm).

Compute effective rates:
```
tax_rates:
  federal_marginal: [from bracket]
  state: [from state — see references/tax-reference.md]
  ltcg_federal: [0%, 15%, or 20% based on income]
  niit: 0.038 if MAGI > $250K MFJ or $200K single, else 0
  effective_ordinary: federal_marginal + state
  effective_ltcg: ltcg_federal + niit + state
```

### Account Classification

After parsing CSVs, present the discovered accounts and use `ask_user` to confirm classifications. Auto-detect what you can, then ask the user to verify:

```
Question — "I found these accounts. Which are locked (can't change investments)?"
  Header: "Locked accts"
  multiSelect: true
  Options: [List each discovered account with auto-detected type]
```

Also ask about any accounts where the user **can change contribution allocations** even if they can't freely choose investments. This is common with employer 401ks — the user may have 3-10 fund choices and control over how new contributions are split.

### Contribution & Savings Information

Gather details about ongoing investments — this drives Phase 3 recommendations:
- **Recurring contributions**: How much per paycheck/month? Into which accounts/funds?
- **Employer 401k contributions**: Current fund allocation percentages
- **User's proposed changes**: If they've already drafted new contribution allocations, collect those for validation

If the user has provided this information in a supplementary file (e.g., a .txt file), parse it rather than re-asking.

### Target Allocation

**If the user already has targets** (from a supplementary file or stated directly):
- Validate they sum to ~100%
- Present them back for confirmation
- Flag any concerns (e.g., 0% bonds with <10yr horizon, 0% international, >50% bonds with 20+yr horizon)

**If the user needs to choose targets**, present allocation templates from `references/allocation-templates.md` using `ask_user`:

```
Question — "Which allocation template fits your situation?"
  Header: "Allocation"
  Options:
    - Pick the template that best matches the user's stated timeline and risk tolerance,
      and mark it "(Recommended)" in the label. Use this mapping:
        Conservative risk + 0-5yr  → Income / Near-Retirement
        Moderate risk + 5-10yr     → Simple 3-Fund or 4-Fund
        Comfortable risk + 10-20yr → Factor-Tilted or Aggressive Growth
        Very comfortable + 20+yr   → Aggressive Growth
    - Include 2-3 other templates as alternatives
    - Always include "Custom" as a final option
```

**Index vs active funds:** After selecting a template, ask the user whether they prefer index funds, actively managed funds, or a blend. Present the tradeoffs neutrally:
- Index funds: lower expense ratios, tax-efficient, consistent market returns
- Active funds: potential for outperformance, higher costs, less tax-efficient (higher turnover)
- Blended: mix of both — common when employer plans offer only active options

The category targets (Large Blend, International, Bonds, etc.) apply regardless of whether the underlying funds are index or active. See `references/allocation-templates.md` for additional guidance.

Validate that targets sum to ~100%. Store in profile.

### Cash Treatment

If significant cash exists (>5% of portfolio), use `ask_user`:

```
Question — "You have $X in cash across accounts. How should we treat it?"
  Header: "Cash plan"
  Options:
    - "Deploy all" — "Include all cash in the optimization"
    - "Keep some as emergency" — "Set aside an emergency fund, deploy the rest"
    - "Keep all as emergency" — "Exclude cash from portfolio targets"
```

### Fund Classification Review

The analysis classifies most common funds automatically (see `references/asset-classification.md`). Present any **unclassified holdings** to the user using `ask_user` and ask them to assign categories.

## Step 4: Analysis

Perform the analysis directly — classify holdings, detect account types, run gap analysis, and assess tax impact. Use the algorithms below.

### Classification Algorithm

Classify each holding using this priority order:

1. **User-specified override** — If the user has explicitly classified a symbol, use that
2. **Cash detection** — Match against known money market symbols: SPAXX, FDRXX, VMFXX, SWVXX, SPRXX, TTTXX; also match if symbol contains "cash" or description contains "money market"
3. **Symbol lookup** — Look up symbol in `references/asset-classification.md` tables
4. **Morningstar category** — If available in the CSV data (Fidelity includes this), use it directly
5. **Keyword matching** — Match fund name/description against keywords (see `references/asset-classification.md` keyword table)
6. **Ask user** — Present unclassified holdings with `ask_user` and request classification

### Account Type Detection

Detect account tax treatment from name heuristics when not explicitly specified:

| Name contains | Account type |
|---|---|
| ROTH | roth |
| TRADITIONAL, ROLLOVER | traditional |
| 401K, 401(K), SELF-EMPLOYED | traditional (unless ROTH 401K) |
| SEP, SEP-IRA | traditional |
| SOLO 401K, INDIVIDUAL 401K | traditional |
| HSA, HEALTH SAVINGS | hsa |
| 529, EDUCATION, COLLEGE | 529 |
| IRA (without ROTH) | traditional |
| TRUST, LIVING TRUST | taxable |
| *(none of the above)* | taxable |

Note: Some employer 401ks have a Roth component. Check contribution screenshots or ask the user if the 401k has both Roth and traditional portions.

### Gap Analysis — Combined Portfolio Framework

This is the core algorithm. When locked accounts exist, compute gaps against the **combined** portfolio, then derive what the controllable portfolio needs.

**Exclude from the analysis:** Holdings in 529/Education accounts. These have a separate purpose and should not count toward portfolio targets. Report them in the portfolio snapshot but omit from gap calculations.

```
INPUTS:
  holdings[]          — all parsed holdings with category, account_type, controllable flag
                        (excluding 529/Education accounts)
  targets{}           — category → target percentage (sums to 1.0)

COMPUTE:
  ctrl_total          = sum(value) for controllable holdings
  locked_total        = sum(value) for non-controllable holdings
  combined_total      = ctrl_total + locked_total

  ctrl_by_category{}  = sum values by category for controllable holdings
  locked_by_category{}= sum values by category for non-controllable holdings

FOR EACH category in targets:
  combined_target     = targets[category] × combined_total
  locked_provides     = locked_by_category[category] or 0
  ctrl_need           = max(0, combined_target − locked_provides)
  ctrl_has            = ctrl_by_category[category] or 0
  gap                 = ctrl_need − ctrl_has
  gap_pct             = gap / ctrl_total × 100  (if ctrl_total = 0, skip — no controllable assets)

  priority:
    if gap > 0 and |gap_pct| > 5%  → CRITICAL (underweight)
    if gap > 0 and |gap_pct| > 2%  → HIGH
    if gap > 0                     → MEDIUM
    if gap < 0 and |gap_pct| > 5%  → REDUCE (overweight)
    if gap < 0                     → OVER
    if gap ≈ 0                     → AT TARGET
```

**Critical insight**: A locked 401k with $500K in Large Blend means the controllable portfolio needs far less Large Blend than standalone targets suggest. Always present the combined view.

#### Target Date and Balanced Fund Handling

Target Date and Balanced funds contain a mix of stocks and bonds. If included as-is, the gap analysis can't see what's inside them. Decompose them before running the analysis:

- **Target Date funds** — Estimate the equity/bond split from the target year. Rough glide path: subtract the target year from 2065 and use that as the bond percentage. Example: Target 2045 ≈ 20% bonds / 80% equity. Split the equity portion as ~60% US Large Blend / 25% International / 15% other.
- **Balanced funds** — Use the fund's stated split (e.g., "60/40 balanced" → 60% Large Blend, 40% Bonds).
- If the exact composition is unclear, ask the user or use a conservative 60/40 estimate.
- Apply the decomposed values to the appropriate categories before running the gap math.

### Tax Impact Analysis

Identify tax-inefficient placements in controllable accounts:

**Tax-inefficient assets in taxable accounts:**
- Bonds → interest taxed at ordinary rates
- REITs/Real Estate → distributions taxed at ordinary rates
- Flag if position value > $1,000

**Low-growth assets wasting Roth space:**
- Bonds or Cash in Roth accounts → tax-free growth wasted
- Flag if position value > $500

**For each flagged position, compute:**
```
tax_on_sale           = max(0, gain) × effective_ltcg_rate
annual_tax_drag_saved = position_value × distribution_yield × ordinary_rate
payback_years         = tax_on_sale / annual_tax_drag_saved
```

Typical distribution yields: HY bonds 4-6%, IG bonds 2-4%, REITs 2-4%, equity index 1-2%.

Generally worth fixing if payback < 5 years.

### Contribution Alignment Analysis

Compare current recurring contribution allocations against the gap analysis:

```
FOR EACH category:
  current_contribution_pct = amount going to this category / total contributions
  target_pct              = target allocation percentage
  gap_direction           = from gap analysis (underweight/overweight/at target)

  FLAG if:
    - Contributing to an overweight category (worsening the gap)
    - Zero contributions to a critically underweight category
    - Locked account contributions misaligned with overall portfolio gaps
```

Present a side-by-side: current contributions vs recommended contributions based on gaps. If the user has proposed new contributions, validate those against the gaps too.

### Presenting Results

Walk through findings conversationally. Highlight:

1. **Biggest gaps** — Categories most underweight (by $ and %)
2. **Most overweight** — Categories to stop buying or reduce
3. **Tax issues** — Bonds/REITs in taxable, low-growth assets in Roth
4. **Cash drag** — Uninvested cash earning below-market returns
5. **Expense ratio wins** — High-ER funds that have low-cost alternatives
6. **Embedded gains** — Large positions that are expensive to sell (tax cost)
7. **Contribution misalignment** — Where ongoing investments worsen gaps

## Step 5: Recommendations

Generate a prioritized action plan. Organize by phase:

### Phase Structure

**Phase 1 — Immediate, high-impact, low/no tax cost:**
- Deploy uninvested cash in retirement accounts
- Roth account cleanup (sell/swap freely — no tax impact)
- Fix tax-inefficient placements in Roth (bonds/cash → high-growth equity)
- Stop buying overweight categories

**Phase 2 — Near-term, low tax cost:**
- Sell tax-inefficient positions from taxable if payback < 5 years
- Deploy taxable cash into appropriate investments
- Redirect dividend reinvestment from overweight to underweight categories

**Phase 3 — Ongoing allocation changes:**
- Restructure recurring investments (contributions per paycheck/month)
- Redirect new money to underweight categories
- Adjust employer 401k contribution allocations if possible

**Phase 4 — Long-term / deferred:**
- Hold large embedded-gain positions; dilute naturally over time
- Schedule future tranches for gradual transitions
- Roth conversion planning for early retirement years
- Donor-advised fund strategy for highly appreciated positions (see below)

### For Each Recommendation

Include:
- **What** to do (specific fund, amount, account)
- **Why** (which gap it fills, tax benefit, expected improvement)
- **Tax cost** (if any) and **payback period**
- **Priority** (critical / high / medium / low)

### Index vs Active Fund Recommendations

When recommending specific fund swaps, respect the user's stated preference from Step 3:
- If they prefer index funds, recommend low-cost index options
- If they prefer active funds or a blend, their existing active fund may be fine if the expense ratio is reasonable (generally <0.75%) and they prefer it
- The key insight: **asset allocation matters far more than index-vs-active** for most investors. Focus recommendations on getting the right category exposure rather than insisting on index funds.

### Tax-Efficient Location Principles

Reference `references/tax-reference.md` for detailed guidance:
- Tax-deferred (traditional): bonds, REITs, high-turnover funds
- Roth: highest expected growth (small value, factor tilts, aggressive equity)
- Taxable: broad index funds, tax-managed funds, individual stocks

### Municipal Bond Strategy (High-Bracket Taxpayers)

When effective ordinary rate exceeds ~35% (federal + state), municipal bonds become compelling for taxable accounts:
- Tax-equivalent yield = muni yield / (1 - effective_ordinary_rate)
- Example: at 40% combined rate, a 4% muni yield = 6.7% pre-tax equivalent
- Recommend when: bond allocation is needed, insufficient tax-advantaged space, high ordinary rate
- Suggest the user search for muni bond funds at their brokerage (most offer state-specific and national options)

### Donor-Advised Fund Strategy (Highly Appreciated Positions)

When a position has large embedded gains AND the taxpayer is charitably inclined:
- Donating appreciated stock to a DAF avoids LTCG entirely
- Plus generates a charitable deduction at fair market value
- Most effective for positions that are nearly all gain (e.g., >80% unrealized gain)
- Mention this as an option when individual stock positions have very large embedded gains — don't assume charitable intent, just note the tax efficiency if they do give

### Concentrated Stock Positions

Flag any single holding exceeding 10% of the total portfolio. Concentrated positions — especially employer stock from RSUs, ESPPs, or stock options — are one of the most common and dangerous portfolio risks.

**When a concentrated position is found:**
- Note the concentration percentage and embedded gain
- Discuss diversification timeline: selling a fixed dollar amount or percentage per quarter/year
- If the position has large embedded gains, mention tax-efficient strategies:
  - **Systematic selling** — Spread sales across tax years to stay in lower brackets
  - **Charitable giving** — Donate appreciated shares to a DAF (see Donor-Advised Fund section above)
  - **Gifting** — Gift shares to family members in lower brackets (annual gift tax exclusion applies)
- For employer stock in a 401k: recommend reducing the allocation in favor of diversified funds, and redirecting future contributions away from company stock
- Frame the risk clearly: a single stock can lose 50-90% of its value. Diversification is the primary defense.

Do not pressure users to sell immediately — concentrated positions often have emotional or practical constraints (vesting schedules, blackout periods, loyalty). Present the risk and options, then let them decide on timing.

### Validating User's Proposed Changes

If the user came with proposed changes (new contribution allocations, target trades, etc.):
1. Compare each proposed action against the gap analysis
2. Flag proposed actions that worsen gaps (e.g., contributing to an already-overweight category)
3. Identify gaps the proposal doesn't address (e.g., no bond allocation when bonds are significantly underweight)
4. Suggest specific adjustments to improve the proposal

### Locked Account Contribution Recommendations

Even if the user can't change existing holdings in a locked 401k, they can often change how new contributions are allocated. Recommend adjustments:
- If the locked account is overweight in a category, reduce that fund's contribution percentage
- If the locked account can help fill a gap (e.g., has an international index fund), increase that allocation
- Present current vs recommended contribution percentages

## Step 6: Report

Use `ask_user` to determine the output format:

```
Question — "How would you like the results?"
  Header: "Output"
  Options:
    - "Interactive discussion" — "Walk through findings together, I'll ask questions"
    - "Markdown report" — "Generate a detailed written plan I can save"
    - "Both" — "Discuss first, then generate a report"
```

Default to interactive discussion if not asked. When the user wants a written report, generate a markdown file with:

```markdown
# Portfolio Analysis Plan
**Date:** [date]
**Prepared for:** [name]

> *This analysis is for informational and educational purposes only. It is not investment, tax, or financial advice. Consult a qualified financial advisor before making investment decisions. Tax rates and fund data may not reflect current values — verify before acting.*

## Executive Summary
[Key findings, total portfolio value, biggest gaps, estimated annual benefit]

## Current Portfolio Snapshot
[Account table, holdings by account, by category]

## Allocation Gap Analysis
[Current vs target table with gaps and priorities]
[Combined framework if locked accounts exist]

## Recommended Actions
### Phase 1: Immediate
[Specific trades with tax impact]

### Phase 2: Near-Term
[Taxable cleanup, cash deployment]

### Phase 3: Ongoing
[Recurring investment changes, contribution redirects]

### Phase 4: Long-Term
[Hold/dilute strategies, future planning]

## Appendix
[Detailed holdings, classification notes, methodology]
```

Offer to save as `analysis/portfolio-analysis-plan.md` or user's preferred location.

## Analysis Options

Beyond the standard gap analysis + action plan, offer these when relevant. Use `ask_user` with multiSelect to let the user choose:

```
Question — "Which additional analyses would you like?"
  Header: "Analyses"
  multiSelect: true
  Options:
    - "Fee analysis" — "Weighted expense ratio, identify high-cost funds"
    - "Tax-loss harvesting scan" — "Find positions with losses to offset gains"
    - "Concentration risk" — "Flag positions >10% of portfolio"
    - "Income projection" — "Expected dividend/interest income by account"
```

Full list of available analyses:

- **Style box analysis** — 9-box grid (size x style) showing portfolio tilt
- **Tax-loss harvesting scan** — Find positions with losses that could offset gains
- **Fee analysis** — Total weighted expense ratio, identify high-cost funds (>1% warrants discussion; 0.50% active funds may be reasonable)
- **Concentration risk** — Single positions >10% of portfolio
- **Sector exposure** — Breakdown by GICS sector (if individual stocks held)
- **Income projection** — Expected dividend/interest income by account type
- **Roth conversion modeling** — Compare convert-now vs convert-in-retirement scenarios
- **Withdrawal sequencing** — Which accounts to draw from first in retirement

## References

- `references/allocation-templates.md` — Preset allocation templates with guidance
- `references/tax-reference.md` — Federal/state tax rates, asset location rules, common scenarios
- `references/asset-classification.md` — Fund/ETF classification database, employer 401k patterns
