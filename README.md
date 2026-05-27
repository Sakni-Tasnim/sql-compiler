# 🗄️ SQL Compiler — Flex / Bison + Tkinter GUI

> Write SQL. Compile it. See errors in real time.

A fully functional **SQL compiler** built from scratch using **Flex** (lexer) and **Bison/Yacc** (parser), with a dark-themed **Python Tkinter GUI**. Runs on Linux  type or load SQL queries and get instant syntax validation with detailed error messages including line number and token location.

---

## ✨ Features

- 📝 **Lexer (Flex)** : tokenizes SQL keywords, identifiers, operators, and symbols
- 🧩 **Parser (Bison/Yacc)** : validates SQL grammar rules
- ✅ **Supported SQL statements:**
  - `SELECT` — with `*` or column list, single or multiple tables
  - `INSERT INTO ... VALUES`
  - `UPDATE ... SET ... WHERE`
  - `DELETE FROM ... WHERE`
  - `CREATE TABLE / DATABASE`
  - `DROP TABLE / DATABASE`
  - `ALTER TABLE ... ADD`
- 🔴 **Detailed error messages** : line number + unexpected token + expected token
- 🖥️ **Tkinter GUI** : dark VS Code-inspired interface with INPUT and OUTPUT panels
- 📂 **File loading** : load `.sql` or `.txt` files directly into the editor
- 🔁 **Case-insensitive** : SQL keywords work in any case (`SELECT`, `select`, `Select`)

---

## 📸 Screenshots

| Empty Interface | Error Detection | Build Commands |
|----------------|-----------------|----------------|
| ![Interface](screenshots/interface.png) | ![Error](screenshots/error_detection.png) | ![Build](screenshots/build.png) |

---

## 🏗️ Project Structure

```
sql-compiler/
├── lexer.l          # Flex lexer : tokenization rules
├── parser.y         # Bison parser : grammar rules + error reporting
├── interface.py     # Python Tkinter GUI
└── screenshots/
```

> ⚙️ Generated files (`lex.yy.c`, `parser.tab.c`, `parser.tab.h`, `sql_compiler`) are excluded from the repo — build them locally using the commands below.

---

## 🚀 Getting Started

### Prerequisites (Linux/Ubuntu)

```bash
sudo apt install flex bison gcc python3
```

### Build & Run

```bash
# Step 1 : Generate lexer
flex lexer.l

# Step 2 : Generate parser
bison -d parser.y

# Step 3 : Compile
gcc parser.tab.c lex.yy.c -o sql_compiler

# Step 4 : Launch GUI
python3 interface.py
```

---

## 🔬 How It Works

1. User types SQL in the INPUT panel or loads a `.sql` file
2. GUI calls the compiled `sql_compiler` binary via `subprocess`
3. **Flex** tokenizes the input  identifies keywords, identifiers, operators
4. **Bison** validates the token stream against SQL grammar rules
5. Valid statements print: `Line X: Valid SELECT` (or INSERT, CREATE, etc.)
6. Invalid statements print: `Line X | Error: syntax error | (At token: 'TOKEN')`
7. Output displayed in color  green for success, red for errors

---

## 💡 Example

**Input:**
```sql
CREATE DATABASE my_data;
SELECT * FROM users;
DROP TABLE old_records;
INSERT INTO logs VALUES (500);
SELECT name FROM users
DROP DATABASE temp;
```

**Output:**
```
ERRORS
Line 6 | Error: syntax error, unexpected DROP, expecting SEMICOLON | (At token: 'DROP')
```

> Line 5 is missing a semicolon — the compiler catches it precisely.

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Lexer | Flex (Fast Lexical Analyzer) |
| Parser | Bison / Yacc |
| Compiler | GCC |
| GUI | Python Tkinter |
| Platform | Linux / Lubuntu VM |

---

## 👤 Author

**Sakni Tasnim**  
Telecommunications & Computer Engineering Student  
🔗 [GitHub](https://github.com/Sakni-Tasnim) • [LinkedIn](https://www.linkedin.com/in/sakni-tasnim-0bb856389)

---

## 📄 License

Feel free to use, modify, and build on this project.
