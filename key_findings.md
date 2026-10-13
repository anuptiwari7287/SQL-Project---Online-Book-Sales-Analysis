# Key Findings (calculated from supplied CSV files)

These findings were calculated from the uploaded CSVs using Python as a cross-check. Re-run the SQL queries after importing the data to verify the same totals.

## Dataset overview
- Books: 500
- Customers: 500
- Orders: 500
- Date range: 2022-12-09 to 2024-12-07
- Unique book genres: 7
- Countries represented in customer table: 215

## Overall performance
- Total order revenue: $75,628.66
- Number of order records: 500
- Units ordered: 2,697
- Average order value (mean of order Total_Amount): $151.26
- Customers with at least two order records: 139

## Highlights
- Highest-revenue month in the dataset: 2023-05 ($5,110.81).
- Highest-spending customer ID: 457 ($1,398.90).
- Highest-revenue book ID: 120 ($1,104.69).
- Highest-revenue genre: Romance ($13,086.98).
- Highest-revenue country: Cambodia ($1,398.90).

## Revenue by genre
| Genre | Revenue | Units sold | Order records |
|---|---:|---:|---:|
| Romance | $13,086.98 | 439 | 80 |
| Mystery | $12,788.45 | 504 | 83 |
| Science Fiction | $11,770.51 | 447 | 84 |
| Non-Fiction | $11,603.06 | 351 | 71 |
| Fantasy | $11,238.38 | 446 | 81 |
| Biography | $7,870.06 | 285 | 55 |
| Fiction | $7,271.22 | 225 | 46 |

## Interpretation notes
- These are descriptive findings, not proof of causation.
- `Total_Amount` is treated as the revenue measure supplied in the dataset; its definition (gross/net, discounts, tax, returns) is not documented.
- The stock field is a current inventory snapshot. Subtracting all historical order quantities from current stock would not reliably calculate remaining inventory unless stock history and restocking are known.
- The CSVs contain customer-like contact fields. Before publishing, confirm that all personal-looking data is synthetic or you have permission to share it. If uncertain, remove or anonymize Email and Phone before uploading.
