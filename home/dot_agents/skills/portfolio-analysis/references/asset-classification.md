# Asset Classification Guide

## Table of Contents
- [Standard Categories](#standard-categories)
- [Classification Hierarchy](#classification-hierarchy)
- [Common Fund/ETF Mappings](#common-fundetf-mappings)
- [Individual Stocks](#individual-stocks)
- [Employer 401k Plans](#employer-401k-plans)

---

## Standard Categories

| Category | Description | Example Funds |
|---|---|---|
| Large Blend | US large-cap total market | VTI, VOO, FXAIX, SPY |
| Large Growth | US large-cap growth | QQQ, VUG, FSPGX, IWF |
| Large Value | US large-cap value | VTV, FVAL, SCHD, IWD |
| Mid Cap | US mid-cap (blend/growth/value) | VO, IJH, FSMAX, MDY |
| Small Cap | US small-cap (incl. small value) | VB, AVUV, IWM, IJR |
| International | Developed international | VXUS, VEA, FSPSX, FENI |
| Intl Small/Value | International small/value | AVDV, VSS, SCZ, DISV |
| Emerging Markets | Emerging market equities | VWO, IEMG, EEM, SCHE |
| Bonds | Fixed income (all types) | BND, AGG, FXNAX, TLT |
| TIPS | Inflation-protected bonds | TIPS, VTIP, SCHP |
| Real Estate | REITs and real estate funds | VNQ, FRESX, FSRNX, SCHH |
| Cash | Money market, savings, CDs | SPAXX, VMFXX, SWVXX |
| Target Date | Target-date retirement funds | VFFVX, FXIFX |
| Balanced | Multi-asset / target-risk funds | VBIAX, AOM, AOK |
| Commodities | Gold, broad commodities | GLD, IAU, GLDM, PDBC |
| Crypto | Bitcoin/crypto funds | IBIT, BITO, FBTC, ETHE |

---

## Classification Hierarchy

When classifying a holding, use this priority order:

1. **User-specified classification** — Always takes priority
2. **Cash detection** — Match against known money market symbols (SPAXX, FDRXX, VMFXX, SWVXX, SPRXX, TTTXX) or if symbol contains "cash" / description contains "money market"
3. **Known symbol mapping** — From the symbol tables in this document
4. **Morningstar category** — If available in the CSV data (Fidelity includes this column)
5. **Fund name keywords** — Match against category keywords in the fund name/description
6. **Ask the user** — For unclassified holdings, present them and ask

### Fund Name Keyword Matching

| Keywords in Name | Category |
|---|---|
| "total market", "S&P 500", "500 index" | Large Blend |
| "growth", "nasdaq", "technology" | Large Growth |
| "value", "dividend", "equity income" | Large Value |
| "mid cap", "midcap", "extended market" | Mid Cap |
| "small cap", "smallcap", "russell 2000" | Small Cap |
| "international", "foreign", "ex-US", "developed" | International |
| "emerging", "EM" | Emerging Markets |
| "bond", "fixed income", "aggregate", "treasury" | Bonds |
| "TIPS", "inflation" | TIPS |
| "real estate", "REIT" | Real Estate |
| "money market", "government cash" | Cash |
| "target", "retirement 20XX", "freedom 20XX" | Target Date |
| "balanced", "moderate", "conservative alloc", "target risk" | Balanced |
| "gold", "commodity", "commodities", "precious metal" | Commodities |
| "bitcoin", "crypto", "digital asset" | Crypto |

---

## Common Fund/ETF Mappings

### Vanguard
| Symbol | Name | Category |
|---|---|---|
| VTI | Total Stock Market | Large Blend |
| VOO | S&P 500 | Large Blend |
| VTSAX | Total Stock Market Admiral | Large Blend |
| VFIAX | 500 Index Admiral | Large Blend |
| VUG | Growth | Large Growth |
| VTV | Value | Large Value |
| VO | Mid-Cap | Mid Cap |
| VB | Small-Cap | Small Cap |
| VBR | Small-Cap Value | Small Cap |
| VXUS | Total International | International |
| VEA | Developed Markets | International |
| VWO | Emerging Markets | Emerging Markets |
| BND | Total Bond Market | Bonds |
| VNQ | Real Estate | Real Estate |

### Fidelity
| Symbol | Name | Category |
|---|---|---|
| FXAIX | 500 Index | Large Blend |
| FSKAX | Total Market Index | Large Blend |
| FSPGX | Large Cap Growth Index | Large Growth |
| FCNTX | Contrafund | Large Growth |
| FBGRX | Blue Chip Growth | Large Growth |
| FVAL | Value Factor ETF | Large Value |
| FSMAX | Extended Market Index | Mid Cap |
| FCPGX | Small Cap Growth Index | Small Cap |
| FSPSX | International Index | International |
| FENI | International Sustainability | International |
| FXNAX | US Bond Index | Bonds |
| FAGIX | Capital & Income (HY Bond) | Bonds |
| FRESX | Real Estate Investment | Real Estate |
| FSRNX | Real Estate Index | Real Estate |

### Schwab
| Symbol | Name | Category |
|---|---|---|
| SWTSX | Total Stock Market Index | Large Blend |
| SCHB | Broad Market ETF | Large Blend |
| SCHG | Large-Cap Growth ETF | Large Growth |
| SCHV | Large-Cap Value ETF | Large Value |
| SCHD | US Dividend Equity ETF | Large Value |
| SCHM | Mid-Cap ETF | Mid Cap |
| SCHA | Small-Cap ETF | Small Cap |
| SCHF | International Equity ETF | International |
| SCHE | Emerging Markets ETF | Emerging Markets |
| SCHZ | US Aggregate Bond ETF | Bonds |
| SCHH | REIT ETF | Real Estate |

### Avantis / DFA (Factor Tilts)
| Symbol | Name | Category |
|---|---|---|
| AVUV | US Small Cap Value ETF | Small Cap |
| AVDV | Intl Small Cap Value ETF | Intl Small/Value |
| AVES | Emerging Markets Value ETF | Emerging Markets |
| AVLV | US Large Cap Value ETF | Large Value |
| DFAC | US Core Equity 2 | Large Blend |
| DFAT | US Targeted Value | Small Cap |
| DFAX | International Core Equity | International |

### SPDR / Invesco
| Symbol | Name | Category |
|---|---|---|
| SPY | S&P 500 ETF Trust | Large Blend |
| QQQ | Nasdaq-100 ETF | Large Growth |
| MDY | S&P MidCap 400 ETF | Mid Cap |

### iShares / BlackRock
| Symbol | Name | Category |
|---|---|---|
| IVV | Core S&P 500 | Large Blend |
| ITOT | Core S&P Total US Stock Market | Large Blend |
| IWF | Russell 1000 Growth | Large Growth |
| IWD | Russell 1000 Value | Large Value |
| IWR | Russell Mid-Cap | Mid Cap |
| IJH | Core S&P Mid-Cap | Mid Cap |
| IWM | Russell 2000 | Small Cap |
| IJR | Core S&P Small-Cap | Small Cap |
| IXUS | Core MSCI Total International | International |
| EFA | MSCI EAFE | International |
| IEMG | Core MSCI Emerging Markets | Emerging Markets |
| AGG | Core US Aggregate Bond | Bonds |
| IUSB | Core Total USD Bond Market | Bonds |
| TLT | 20+ Year Treasury Bond | Bonds |
| IEF | 7-10 Year Treasury Bond | Bonds |
| SHY | 1-3 Year Treasury Bond | Bonds |
| TIP | TIPS Bond | TIPS |
| IYR | US Real Estate | Real Estate |
| IBIT | Bitcoin Trust | Crypto |

### T. Rowe Price
| Symbol | Name | Category |
|---|---|---|
| PREIX | Equity Index 500 | Large Blend |
| PRGFX | Growth Stock | Large Growth |
| TRBCX | Blue Chip Growth | Large Growth |
| TRVLX | Value | Large Value |
| RPMGX | Mid-Cap Growth | Mid Cap |
| TRMCX | Mid-Cap Value | Mid Cap |
| OTCFX | New Horizons (Small/Mid Growth) | Small Cap |
| PRSVX | Small-Cap Value | Small Cap |
| PIEQX | International Equity Index | International |
| PRIDX | International Discovery (Intl Small) | Intl Small/Value |
| PRMSX | Emerging Markets Stock | Emerging Markets |
| PBDIX | US Bond Enhanced Index | Bonds |

### American Funds
| Symbol | Name | Category |
|---|---|---|
| AGTHX | Growth Fund of America | Large Growth |
| AIVSX | Investment Company of America | Large Blend |
| AWSHX | Washington Mutual Investors | Large Value |
| AMECX | Income Fund of America | Large Value |
| ANWPX | New Perspective | International |
| AEPGX | EuroPacific Growth | International |
| SMCWX | Smallcap World | Small Cap |
| ABNDX | Bond Fund of America | Bonds |
| ABALX | American Balanced | Balanced |
| AMRFX | American Mutual | Large Value |

### TIAA
| Symbol | Name | Category |
|---|---|---|
| TIEIX | Equity Index | Large Blend |
| TIIEX | International Equity Index | International |
| TIBFX | Bond Index | Bonds |
| TIRLX | Real Estate Securities | Real Estate |
| TILGX | Large-Cap Growth Index | Large Growth |
| TILVX | Large-Cap Value Index | Large Value |
| TISBX | Small-Cap Blend Index | Small Cap |

---

## Individual Stocks

Classify individual stocks by their market cap and style:

| Market Cap | Metric | Classification |
|---|---|---|
| >$200B | Mega cap | Large (Blend/Growth/Value by sector) |
| $10B-$200B | Large cap | Large (Blend/Growth/Value by sector) |
| $2B-$10B | Mid cap | Mid Cap |
| <$2B | Small cap | Small Cap |

**Growth vs Value heuristics for individual stocks:**
- High P/E (>25), tech/healthcare sector → Growth
- Low P/E (<15), financials/utilities/energy → Value
- Mixed metrics → Blend

**Common mega-cap classifications:**
- AAPL, MSFT, GOOGL, AMZN, NVDA, META, TSLA → Large Growth
- BRK/B, JPM, JNJ, PG, XOM → Large Value / Large Blend
- International ADRs (TCOM, BABA, TSM) → International

---

## Employer 401k Plans

Employer 401k plans often use custom fund names. Common patterns:

| Fund Name Pattern | Category |
|---|---|
| "US Large Cap Equity", "S&P 500", "Large Cap Index" | Large Blend |
| "US Small/Mid Cap", "SMID Cap", "Extended Market" | Mid Cap |
| "International Equity", "Non-US Equity", "Foreign Stock" | International |
| "Emerging Markets" | Emerging Markets |
| "Bond Index", "Fixed Income", "Stable Value" | Bonds |
| "Target 20XX", "Retirement 20XX" | Target Date |
| "Company Stock" | Classify by company's market cap/style |
| "Balanced", "Moderate", "LifePath", "LifeStrategy" | Balanced |
| "Stable Value", "Capital Preservation" | Bonds |

When encountering unknown 401k fund names, present them to the user and ask for classification.
