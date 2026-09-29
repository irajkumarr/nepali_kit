# Nepal Government Fiscal Year (आर्थिक वर्ष) Specification

## 1. Legal & Regulatory Definition

In Nepal, the official government, banking, tax, and accounting fiscal year (*Aarthik Barsha* / आर्थिक वर्ष) is defined as follows:

1. **Cycle Start:**  
   Begins on **Shrawan 1** (१ श्रावण) of the starting Bikram Sambat (BS) year.
   - In Gregorian (AD) calendar, this corresponds approximately to **mid-July** (typically July 16 or 17).
2. **Cycle End:**  
   Concludes on the **last day of Ashadh** (असार मसान्त) of the following Bikram Sambat year.
   - The month of Ashadh typically contains 31 or 32 days depending on the astronomical calendar.
   - In the Gregorian calendar, this corresponds to **mid-July** of the subsequent year.
3. **Fiscal Year Notation:**  
   Denoted as `YYYY/YY` or `YYYY/YYYY` (e.g. `2081/82` or `२०८१/८२`).
   - The first four digits denote the BS year in which the fiscal year begins (Shrawan 1).
   - The final two digits denote the two-digit year in which the fiscal year terminates (Ashadh).

---

## 2. Month-to-Fiscal-Year Mapping Rule

Given a Bikram Sambat date with month $M \in [1, 12]$ and year $Y$:

$$\text{FiscalYear}(Y, M) = \begin{cases} 
Y / (Y + 1) & \text{if } M \ge 4 \text{ (Shrawan through Chaitra)} \\
(Y - 1) / Y & \text{if } M < 4 \text{ (Baisakh through Ashadh)}
\end{cases}$$

### Detailed Month Breakdown:
| Month Name | BS Month Index | Fiscal Year Assigned | Fiscal Quarter |
|---|:---:|:---:|:---:|
| **Baisakh** (बैशाख) | 1 | $(Y - 1) / Y$ | **Q4** (Final Quarter) |
| **Jestha** (जेठ) | 2 | $(Y - 1) / Y$ | **Q4** (Final Quarter) |
| **Ashadh** (असार) | 3 | $(Y - 1) / Y$ | **Q4** (Final Quarter) |
| **Shrawan** (श्रावण) | 4 | $Y / (Y + 1)$ | **Q1** (First Quarter) |
| **Bhadra** (भाद्र) | 5 | $Y / (Y + 1)$ | **Q1** (First Quarter) |
| **Ashwin** (आश्विन) | 6 | $Y / (Y + 1)$ | **Q1** (First Quarter) |
| **Kartik** (कार्तिक) | 7 | $Y / (Y + 1)$ | **Q2** (Second Quarter) |
| **Mangsir** (मंसिर) | 8 | $Y / (Y + 1)$ | **Q2** (Second Quarter) |
| **Poush** (पौष) | 9 | $Y / (Y + 1)$ | **Q2** (Second Quarter) |
| **Magh** (माघ) | 10 | $Y / (Y + 1)$ | **Q3** (Third Quarter) |
| **Falgun** (फाल्गुन) | 11 | $Y / (Y + 1)$ | **Q3** (Third Quarter) |
| **Chaitra** (चैत) | 12 | $Y / (Y + 1)$ | **Q3** (Third Quarter) |

---

## 3. Financial Quarters (त्रैमासिक) Breakdown

For any fiscal year $Y_1 / Y_2$:
- **Q1 (प्रथम त्रैमासिक):** Shrawan 1, $Y_1$ – Ashwin last day, $Y_1$ (Months 4 to 6)
- **Q2 (दोस्रो त्रैमासिक):** Kartik 1, $Y_1$ – Poush last day, $Y_1$ (Months 7 to 9)
- **Q3 (तेस्रो त्रैमासिक):** Magh 1, $Y_1$ – Chaitra last day, $Y_1$ (Months 10 to 12)
- **Q4 (चौथो त्रैमासिक):** Baisakh 1, $Y_2$ – Ashadh last day, $Y_2$ (Months 1 to 3)

---

## 4. API Usage in Business Applications

### Invoicing & Financial Accounting
```dart
import 'package:nepali_kit/nepali_kit_core.dart';

// Current fiscal year
final fy = NepaliFiscalYear.current();
print('Fiscal Year: ${fy.format()}'); // "२०८१/८२"

// Invoice date assignment
final invoiceDate = NepaliDate(2081, 3, 15); // Ashadh 15, 2081
final invoiceFy = NepaliFiscalYear.fromDate(invoiceDate);
print(invoiceFy.format(Language.english)); // "2080/81"

// Quarter resolution
final quarter = NepaliFiscalQuarter.fromDate(invoiceDate);
print(quarter.format(Language.english)); // "2080/81 Q4"
```
