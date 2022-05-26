# Batch Script Utils and Examples

## 1. Naming Conventions

### 1.1. Functions

Function names are capitalized and begin with the 'F' character. For example:

```bash
CALL :FFUNCTION
GOTO :EOF

:FFUNCTION
    ECHO The FFUNCTION function has been executed!
    EXIT /B 0
```

### 1.2. Variables

Variables are written in pascal case and begin with the 'V' character. For example:

```bash
SET /A VResultData=1
```
