# Allocation Templates

## Table of Contents
- [Global Market Weight](#global-market-weight)
- [Simple 3-Fund](#simple-3-fund)
- [4-Fund with International](#4-fund-with-international)
- [Factor-Tilted](#factor-tilted)
- [Age-Based Rules](#age-based-rules)
- [Aggressive Growth](#aggressive-growth)
- [Income / Near-Retirement](#income--near-retirement)
- [Active and Blended Portfolios](#active-and-blended-portfolios)
- [Custom Template Guidance](#custom-template-guidance)

---

## Global Market Weight

Own the world at approximate market-cap weights. The most academically neutral starting point — no active bets on regions or factors.

```json
{
  "Large Blend": 0.42,
  "International": 0.30,
  "Emerging Markets": 0.08,
  "Bonds": 0.15,
  "Cash": 0.05
}
```

**Best for:** Passive investors who want to match global market proportions (~60/40 US/intl equity split within equities). Simplest "set and forget" approach.
**Key funds:** VT or VTI+VXUS (equity), BND or BNDW (bonds).
**Adjust:** Shift bond allocation for time horizon. Some add 5-10% small cap tilt.

---

## Simple 3-Fund

The classic Boglehead portfolio. Low cost, broadly diversified, minimal maintenance.

```json
{
  "Large Blend": 0.50,
  "International": 0.20,
  "Bonds": 0.30
}
```

**Best for:** Beginners, hands-off investors, those who want simplicity.
**Adjust:** Reduce bonds for longer time horizons; increase for shorter.

---

## 4-Fund with International

Adds international tilt for better global diversification.

```json
{
  "Large Blend": 0.40,
  "International": 0.30,
  "Bonds": 0.20,
  "Cash": 0.10
}
```

**Best for:** Investors who want more international exposure than the 3-fund but with a simpler structure than factor-tilted. Good middle ground.
**Adjust:** Reduce cash allocation if you have a separate emergency fund.

---

## Factor-Tilted

Tilts toward value and small-cap factors (higher expected returns, more volatility). Based on Fama-French research.

```json
{
  "Large Value": 0.14,
  "Large Blend": 0.15,
  "Large Growth": 0.10,
  "Mid Cap": 0.07,
  "Small Cap": 0.10,
  "International": 0.19,
  "Intl Small/Value": 0.07,
  "Bonds": 0.08,
  "Real Estate": 0.05,
  "Cash": 0.05
}
```

**Best for:** Long time horizons (10+ years), higher risk tolerance, believers in factor premiums.
**Key funds:** AVUV (US small value), AVDV (intl small value), FVAL/VTV (large value).

---

## Aggressive Growth

Maximizes equity exposure for long-horizon investors comfortable with 40%+ drawdowns.

```json
{
  "Large Blend": 0.25,
  "Large Growth": 0.15,
  "Small Cap": 0.15,
  "International": 0.25,
  "Intl Small/Value": 0.10,
  "Real Estate": 0.05,
  "Cash": 0.05
}
```

**Best for:** 15+ year horizon, high risk tolerance, early accumulators.

---

## Income / Near-Retirement

Conservative allocation emphasizing income and capital preservation.

```json
{
  "Large Blend": 0.20,
  "Large Value": 0.10,
  "International": 0.10,
  "Bonds": 0.35,
  "Real Estate": 0.05,
  "Cash": 0.10,
  "TIPS": 0.10
}
```

**Best for:** Within 5 years of retirement, low risk tolerance, income needs.

---

## Age-Based Rules

Simple heuristics for target bond allocation:

- **Age in bonds:** Hold your age as a percentage in bonds (e.g., age 40 = 40% bonds). Conservative.
- **Age minus 20 in bonds:** (e.g., age 40 = 20% bonds). More aggressive — better for those with pensions or high savings rates.
- **120 minus age in stocks:** (e.g., age 40 = 80% stocks). Modern variant accounting for longer lifespans.

Apply the equity portion using any of the templates above (e.g., factor-tilted equity with age-based bond allocation).

---

## Active and Blended Portfolios

All templates above use index fund examples, but **the category targets apply regardless of whether the underlying funds are index or actively managed**. A user targeting 40% Large Blend can fill that with VTI (index), FCNTX (active), or a mix of both.

### When the user prefers active funds

- Use the same target percentages from any template above
- Substitute active funds in the corresponding categories (e.g., a large-cap growth fund for the "Large Growth" slot)
- Note the tradeoffs neutrally:
  - **Expense ratios** — Active funds typically cost 0.50-1.00%+ vs 0.03-0.20% for index. This compounds significantly over decades but is not inherently disqualifying.
  - **Tax efficiency** — Active funds generate more short-term capital gains from higher turnover. Prefer holding active funds in tax-advantaged accounts when possible.
  - **Consistency** — Index funds deliver market returns reliably. Active funds have wider variance — some outperform, most underperform over long periods, but past underperformance does not guarantee future underperformance either.
- **Key principle:** Asset allocation (how much in stocks vs bonds vs international) drives the large majority of portfolio outcomes. Index-vs-active is a secondary decision. Don't let the perfect be the enemy of the good — a well-allocated portfolio of active funds beats a poorly allocated portfolio of index funds.

### Common blended approach

Many investors hold index funds in accounts they control and active funds in employer plans where choices are limited. This is perfectly fine — optimize allocation across the combined portfolio using the gap analysis framework.

---

## Custom Template Guidance

When users specify custom allocations, validate:

1. **Percentages sum to 100%** (within rounding tolerance of 1%)
2. **No negative allocations**
3. **At least 2 asset classes** for diversification
4. **Bond allocation aligns with time horizon**: Flag if <10% bonds with <10yr horizon, or >50% bonds with 20+ year horizon
5. **International exposure**: Flag if 0% international (home country bias risk)

### Standard Category Names

Use these canonical names for consistency with the analysis engine:

- Large Blend, Large Growth, Large Value
- Mid Cap, Small Cap
- International, Intl Small/Value, Emerging Markets
- Bonds, TIPS
- Real Estate
- Cash
- Target Date (for target-date funds — treat as balanced)
- Balanced (multi-asset / target-risk funds — decompose or treat as blend)
- Commodities (gold, broad commodities — optional, not in most templates)
- Crypto (bitcoin/crypto funds — optional, not in most templates)
