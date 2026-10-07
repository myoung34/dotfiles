# Tax Reference for Portfolio Analysis

> **Data vintage:** These figures reflect 2025 tax law. Brackets and thresholds change annually with inflation adjustments — verify current rates before relying on specific numbers. If the current year is 2027 or later, these figures are likely outdated.

## Table of Contents
- [Federal Tax Rates](#federal-tax-rates)
- [State Income Tax Rates](#state-income-tax-rates)
- [Tax-Efficient Asset Location](#tax-efficient-asset-location)
- [Account Type Tax Treatment](#account-type-tax-treatment)
- [Common Tax Scenarios](#common-tax-scenarios)

---

## Federal Tax Rates (2025-2026)

### Long-Term Capital Gains (LTCG)
Assets held >1 year. Rates by taxable income:

**Married Filing Jointly:**
| Income Range | LTCG Rate |
|---|---|
| $0 - $94,050 | 0% |
| $94,051 - $583,750 | 15% |
| $583,751+ | 20% |

**Single:**
| Income Range | LTCG Rate |
|---|---|
| $0 - $47,025 | 0% |
| $47,026 - $518,900 | 15% |
| $518,901+ | 20% |

**Head of Household:**
| Income Range | LTCG Rate |
|---|---|
| $0 - $63,000 | 0% |
| $63,001 - $551,350 | 15% |
| $551,351+ | 20% |

### Net Investment Income Tax (NIIT)
Additional 3.8% on investment income for MAGI >$250K (MFJ) or >$200K (single).

### Short-Term Capital Gains (STCG)
Assets held ≤1 year — taxed as ordinary income.

### Qualified Dividends
Same rates as LTCG. Most US stock and broad index fund dividends qualify.

### Non-Qualified Dividends
Taxed as ordinary income. Common sources: REITs, bond funds, money markets, some international funds.

### Federal Ordinary Income Brackets (2025)

**Married Filing Jointly:**
| Bracket | Rate |
|---|---|
| $0 - $23,850 | 10% |
| $23,851 - $96,950 | 12% |
| $96,951 - $206,700 | 22% |
| $206,701 - $394,600 | 24% |
| $394,601 - $501,050 | 32% |
| $501,051 - $751,600 | 35% |
| $751,601+ | 37% |

**Single:**
| Bracket | Rate |
|---|---|
| $0 - $11,925 | 10% |
| $11,926 - $48,475 | 12% |
| $48,476 - $103,350 | 22% |
| $103,351 - $197,300 | 24% |
| $197,301 - $250,525 | 32% |
| $250,526 - $626,350 | 35% |
| $626,351+ | 37% |

**Head of Household:**
| Bracket | Rate |
|---|---|
| $0 - $17,000 | 10% |
| $17,001 - $64,850 | 12% |
| $64,851 - $103,350 | 22% |
| $103,351 - $197,300 | 24% |
| $197,301 - $250,500 | 32% |
| $250,501 - $626,350 | 35% |
| $626,351+ | 37% |

---

## State Income Tax Rates

Top marginal rates for common states (ask user for their state):

| State | Top Rate | Notes |
|---|---|---|
| California | 13.3% | Highest in US; no LTCG preference |
| New York | 10.9% | NYC adds 3.876% |
| New Jersey | 10.75% | |
| Oregon | 9.9% | No sales tax |
| Minnesota | 9.85% | |
| Wisconsin | 7.65% | |
| Iowa | 5.7% | Phasing down |
| Illinois | 4.95% | Flat rate |
| Colorado | 4.4% | Flat rate |
| Pennsylvania | 3.07% | Flat rate; no tax on retirement income |
| Texas | 0% | No state income tax |
| Florida | 0% | No state income tax |
| Nevada | 0% | No state income tax |
| Washington | 0% | No income tax (7% on LTCG >$270K) |
| Tennessee | 0% | No income tax |

**Important:** Some states treat LTCG differently from ordinary income. Always ask the user's state and verify.

---

## Tax-Efficient Asset Location

### Priority Order for Tax-Deferred Accounts (Traditional IRA/401k)
1. **REITs / Real Estate funds** — Distributions taxed as ordinary income regardless
2. **High-yield bond funds** — Interest taxed as ordinary income
3. **Bond index funds** — Interest taxed as ordinary income
4. **Actively managed funds with high turnover** — Generate frequent STCG

### Priority Order for Roth Accounts
1. **Highest expected growth** — Small cap value, emerging markets, aggressive equity
2. **Factor-tilted funds** (AVUV, AVDV) — Maximize tax-free compounding
3. **International funds** (but note: lose foreign tax credit in Roth)

### Foreign Tax Credit (FTC)

International funds pay foreign taxes on dividends. The treatment differs by account type:

- **Taxable accounts**: Foreign taxes paid generate a US tax credit (Form 1116), effectively making the foreign tax free. This is the strongest argument for holding international funds in taxable.
- **Roth/Traditional IRA**: Foreign taxes are paid but **no credit is available** — the tax is simply lost. The tax drag is typically 0.2-0.5% annually on international equity funds.
- **Decision framework**: If a user holds significant international equity (>15% of portfolio), prefer taxable placement to capture FTC. Exception: if Roth space is limited and the fund has very high expected growth (e.g., EM small value), the tax-free compounding may outweigh the lost FTC.

Typical foreign tax rates on dividends: developed markets 10-15%, emerging markets 10-30%.

### Priority Order for Taxable Accounts
1. **Total market index funds** — Low turnover, qualified dividends, tax-loss harvesting
2. **Tax-managed funds** — Designed for taxable accounts
3. **Individual stocks** — Control over realization timing
4. **Municipal bond funds** — Tax-exempt interest (if in high bracket)
5. **International index funds** — Foreign tax credit usable in taxable

### What NOT to Hold in Taxable
- High-yield bond funds (FAGIX, HYG, JNK)
- REIT funds (VNQ, FRESX)
- Actively managed funds with high turnover
- Funds with large embedded capital gains

---

## Account Type Tax Treatment

| Account Type | Contributions | Growth | Withdrawals |
|---|---|---|---|
| **Taxable** | After-tax | Taxed annually (divs, CG) | LTCG/STCG on sale |
| **Traditional IRA/401k** | Pre-tax (deductible) | Tax-deferred | Ordinary income |
| **Roth IRA/401k** | After-tax | Tax-free | Tax-free (if qualified) |
| **HSA** | Pre-tax | Tax-free | Tax-free (medical) |
| **529** | After-tax | Tax-free | Tax-free (education) |

---

## Common Tax Scenarios

### Selling to Rebalance in Taxable
```
Tax cost = max(0, gain) × effective_ltcg_rate
effective_ltcg_rate = federal_ltcg + niit + state_ltcg
```

### Annual Tax Drag from Bonds in Taxable
```
Annual drag = position_value × distribution_yield × ordinary_income_rate
```

Typical distribution yields:
- High-yield bond funds: 4-6%
- Investment-grade bond index: 2-4%
- REIT funds: 2-4%
- US equity index: 1-2% (mostly qualified)

### Payback Period for Tax-Location Fix
```
payback_years = one_time_tax_cost / annual_tax_drag_saved
```
Generally worth it if payback < 5 years.

### Roth Conversion Considerations
- Convert when income is temporarily low (sabbatical, early retirement, gap year)
- Standard deduction + lower brackets at 10-12% are very efficient
- Compare current marginal rate vs expected rate in retirement
- Don't convert so much that you push into a higher bracket

### Wash Sale Rules
- Cannot deduct a loss if you buy "substantially identical" security within 30 days (before or after)
- Applies across all accounts (taxable, IRA, spouse's accounts)
- Common workaround: use a similar but not identical fund (e.g., VTI ↔ ITOT)

#### Common TLH Swap Pairs

| Category | Fund A | Fund B | Notes |
|---|---|---|---|
| US Total Market | VTI | ITOT | Most common swap |
| S&P 500 | VOO | IVV | Nearly identical |
| International Developed | VXUS | IXUS | Broad international |
| US Aggregate Bond | BND | AGG | Aggregate bond |
| US Small Cap | VB | IJR | Small cap core |
| Emerging Markets | VWO | IEMG | Broad EM |
| US Mid Cap | VO | IJH | Mid cap core |
