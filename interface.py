import tkinter as tk
from tkinter import filedialog, messagebox
import subprocess

BG = "#1e1e1e"
PANEL = "#252526"
BORDER = "#3c3c3c"
FG = "#d4d4d4"
FG_DIM = "#858585"
ACCENT = "#4a9eff"
SUCCESS = "#4ec9a0"
ERROR = "#f44747"
CURSOR = "#aeafad"
FONT_MONO = ("Consolas", 10)
FONT_UI = ("Segoe UI", 9)
FONT_UI_B = ("Segoe UI", 9, "bold")


def on_enter(e): e.widget.config(bg="#2a2d2e")
def on_leave(e): e.widget.config(bg=PANEL)

def run_compiler(input_text=None, file_path=None):
    try:
        if file_path:
            result = subprocess.run(['./sql_compiler', file_path], capture_output=True, text=True)
        else:
            result = subprocess.run(['./sql_compiler'], input=input_text, capture_output=True, text=True)

        output_log.config(state="normal")
        output_log.delete('1.0', tk.END)
        if result.stderr:
            output_log.insert(tk.END, "ERRORS\n", "header_error")
            output_log.insert(tk.END, result.stderr, "error")
        else:
            output_log.insert(tk.END, "OUTPUT\n", "header_ok")
            output_log.insert(tk.END, result.stdout, "success")
        output_log.config(state="disabled")

    except FileNotFoundError:
        messagebox.showerror("Error", "Binary 'sql_compiler' not found. Compile it first.")

def load_file():
    path = filedialog.askopenfilename(filetypes=[("SQL files", "*.txt *.sql")])
    if path:
        with open(path, 'r') as f:
            code_input.delete('1.0', tk.END)
            code_input.insert(tk.END, f.read())
        run_compiler(file_path=path)

def clear_all():
    code_input.delete('1.0', tk.END)
    output_log.config(state="normal")
    output_log.delete('1.0', tk.END)
    output_log.config(state="disabled")

def make_btn(parent, text, command):
    btn = tk.Button(
        parent, text=text, command=command,
        bg=PANEL, fg=FG, font=FONT_UI,
        relief="flat", bd=0, padx=14, pady=5,
        activebackground="#2a2d2e", activeforeground=FG,
        cursor="hand2"
    )
    btn.bind("<Enter>", on_enter)
    btn.bind("<Leave>", on_leave)
    return btn


# --- Root ---
root = tk.Tk()
root.title("SQL Compiler")
root.geometry("860x640")
root.configure(bg=BG)

# --- Top bar ---
topbar = tk.Frame(root, bg="#333333", height=36)
topbar.pack(fill="x")
topbar.pack_propagate(False)
tk.Label(topbar, text="SQL Compiler — Lex / Yacc",
         bg="#333333", fg=FG_DIM, font=FONT_UI).pack(side="left", padx=14, pady=8)

# --- Input section ---
tk.Label(root, text="INPUT", bg=BG, fg=FG_DIM, font=FONT_UI_B).pack(anchor="w", padx=16, pady=(14, 2))

input_frame = tk.Frame(root, bg=BORDER, bd=1)
input_frame.pack(fill="x", padx=16)

code_input = tk.Text(
    input_frame, height=11,
    bg=PANEL, fg=FG, insertbackground=CURSOR,
    font=FONT_MONO, relief="flat", bd=10,
    selectbackground="#264f78", selectforeground=FG
)
code_input.pack(fill="x")

# --- Buttons ---
btn_frame = tk.Frame(root, bg=BG)
btn_frame.pack(anchor="w", padx=16, pady=10)

make_btn(btn_frame, "▶ Run", lambda: run_compiler(input_text=code_input.get("1.0", tk.END))).pack(side="left", padx=(0, 6))
make_btn(btn_frame, "📂 Load File", load_file).pack(side="left", padx=(0, 6))
make_btn(btn_frame, "🗑 Clear", clear_all).pack(side="left")

# --- Output section ---
tk.Frame(root, bg=BORDER, height=1).pack(fill="x", padx=16, pady=(0, 6))
tk.Label(root, text="OUTPUT", bg=BG, fg=FG_DIM, font=FONT_UI_B).pack(anchor="w", padx=16, pady=(0, 2))

output_frame = tk.Frame(root, bg=BORDER, bd=1)
output_frame.pack(fill="both", padx=16, pady=(0, 16), expand=True)

output_log = tk.Text(
    output_frame,
    bg=PANEL, fg=FG, insertbackground=CURSOR,
    font=FONT_MONO, relief="flat", bd=10,
    state="disabled", selectbackground="#264f78", selectforeground=FG
)
output_log.tag_config("header_ok", foreground=SUCCESS, font=("Consolas", 10, "bold"))
output_log.tag_config("header_error", foreground=ERROR, font=("Consolas", 10, "bold"))
output_log.tag_config("success", foreground=SUCCESS)
output_log.tag_config("error", foreground=ERROR)
output_log.pack(fill="both", expand=True)

root.mainloop()
