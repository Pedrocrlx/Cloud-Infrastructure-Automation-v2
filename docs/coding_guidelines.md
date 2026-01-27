# Project Coding Guidelines

## 1. General Principles
* **Language:** All variables, function names, commit messages, and documentation must be in **English**.
* **Simplicity:** Keep it simple ("KISS"). Code must be easy to read and understand. Avoid complex one-liners.
* **Comments:** Code should document itself. Use comments only to explain **why** a complex decision was made, not **what** the code is doing.

## 2. Python (Application)
* **Style:** Follow standard Python conventions (PEP8) but prioritize readability.
* **Structure:**
    * Use descriptive variable names (e.g., `db_connection_string`, not `cs`).
    * Keep functions small and focused on a single task.
* **Error Handling:** Use simple `try/except` blocks only when necessary. Avoid silent failures.

## 3. Terraform (Infrastructure)
* **Naming Convention:** Use `snake_case` for all resource names and variables.
* **Versioning:** Pin exact versions for providers and modules to ensure reproducibility.
    * *Example:* `version = "1.2.0"` (Do not use ranges like `>= 1.0`).
* **Organization:** Output all important endpoints (URLs, IPs) at the end of execution.

## 4. Kubernetes & Helm
* **Labels:** All manifests must include standard labels (e.g., `app`, `environment`) for easy filtering.
* **Resources:** Always define `requests` and `limits` for containers to prevent cluster instability.
* **Security:** Use `securityContext` to run containers as non-root users whenever possible.

## 5. Shell Scripting
* **Logging:** Scripts must be verbose about their execution steps.
* **Formatting:**
    * Do **not** use ANSI colors.
    * Use clear prefixes for logs (e.g., `[INFO]`, `[ERROR]`).
* **Robustness:** Ensure scripts fail immediately if a command errors out (fail-fast).