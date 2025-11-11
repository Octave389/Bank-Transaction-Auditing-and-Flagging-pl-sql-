# GROUP ASSIGNMENT – PL/SQL Batch Transaction Audit
## Faculty of Information Technology
## Department: Software Engineering
## Course Name: Database Programming / PL/SQL

---

## Overview

This project demonstrates a **Batch Transaction Audit** in PL/SQL.  
It processes deposits, withdrawals, and transfers while **flagging high-value withdrawals** for review.  

* **Transaction Audit**: Processes multiple transactions using **records, collections, and associative arrays**.  
* **Critical Flag Handling**: Stops processing immediately if a high-value withdrawal exceeds a defined threshold.

---

## Features

### Transaction Audit

* **Purpose**: To audit multiple banking transactions in a batch.  
* **Example Used**: Transactions for deposit, withdrawal, and transfer.  
* **Highlights**:  

    * Uses an **associative array** to map transaction codes (`W`, `D`, `T`) to readable descriptions.  
    * Uses **records** to define the structure of a transaction.  
    * Uses a **collection** to store multiple transactions.  
    * Flags **high-value withdrawals** and halts processing.  
    * Prints informative messages for auditing.

---

## Technology Stack

* **Language**: PL/SQL  
* **Database**: Oracle or compatible database supporting PL/SQL  
* **Execution**: SQL*Plus, SQL Developer, or any Oracle client  

---

## Batch Transaction Audit – Step by Step Explanation

### 1. Declare Section

```plsql
DECLARE
    TYPE t_code_map IS TABLE OF VARCHAR2(20) INDEX BY VARCHAR2(1);
    v_transaction_types t_code_map;

    TYPE t_transaction_rec IS RECORD (
        account_number VARCHAR2(15),
        transaction_type_code VARCHAR2(1),
        amount NUMBER,
        status VARCHAR2(50)
    );

    TYPE t_transaction_batch IS TABLE OF t_transaction_rec;
    v_batch t_transaction_batch;

    c_high_value_limit CONSTANT NUMBER := 50000;
    v_current_transaction t_transaction_rec;
```

**Explanation:**  
- Defines a **map** to convert transaction codes to readable descriptions.  
- Defines a **record** to store details of a single transaction.  
- Defines a **collection** to hold multiple transactions in a batch.  
- Sets a **constant** for high-value withdrawals.  
- Prepares a variable to hold the **current transaction** during processing.  

---

### 2. Begin Section & Map Transaction Codes

```plsql
BEGIN
    v_transaction_types('W') := 'WITHDRAWAL';
    v_transaction_types('D') := 'DEPOSIT';
    v_transaction_types('T') := 'TRANSFER';
```

**Explanation:**  
- Maps each code to a descriptive string for display purposes.  

---

### 3. Create a Batch of Transactions

```plsql
    v_batch := t_transaction_batch(
        t_transaction_rec('ACC100', 'D', 1000, NULL),
        t_transaction_rec('ACC200', 'W', 55000, NULL),
        t_transaction_rec('ACC300', 'T', 500, NULL)
    );
```

**Explanation:**  
- Creates three sample transactions.  
- Includes a **high-value withdrawal** for testing the critical audit halt.  

---

### 4. Start Processing the Batch

```plsql
    DBMS_OUTPUT.PUT_LINE('--- Starting Batch Audit ---');

    FOR i IN 1 .. v_batch.COUNT LOOP
        v_current_transaction := v_batch(i);

        DBMS_OUTPUT.PUT_LINE('Processing ' || v_transaction_types(v_current_transaction.transaction_type_code) ||
                             ' for $' || v_current_transaction.amount);
```

**Explanation:**  
- Prints a message indicating batch audit has started.  
- Loops through each transaction in the batch.  
- Prints the transaction type and amount.  

---

### 5. Check for High-Value Withdrawals

```plsql
        IF v_current_transaction.transaction_type_code = 'W' 
           AND v_current_transaction.amount > c_high_value_limit THEN
            v_current_transaction.status := 'FLAGGED FOR REVIEW';
            GOTO CRITICAL_AUDIT_HALT;
        ELSE
            v_current_transaction.status := 'CLEARED';
        END IF;

        DBMS_OUTPUT.PUT_LINE('  -> Status: ' || v_current_transaction.status);
    END LOOP;
```

**Explanation:**  
- Flags any **withdrawal exceeding $50,000** and halts processing.  
- Marks other transactions as **CLEARED**.  
- Prints the status for each transaction.  

---

### 6. Batch Completion Message

```plsql
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Batch Audit Complete: All transactions cleared. ---');
    GOTO END_PROCEDURE;
```

**Explanation:**  
- Prints completion message if no high-value transactions were detected.  
- Skips to the end of the program.  

---

### 7. Critical Audit Halt Section

```plsql
<<CRITICAL_AUDIT_HALT>>
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '*** AUDIT HALTED ***');
    DBMS_OUTPUT.PUT_LINE('Critical Flag: High-value withdrawal detected on Account ' || v_current_transaction.account_number);
    DBMS_OUTPUT.PUT_LINE('Processing stopped immediately to prevent further automated actions.');
```

**Explanation:**  
- Displays **critical alert messages** for high-value transactions.  
- Stops further processing.  

---

### 8. End Procedure

```plsql
<<END_PROCEDURE>>
    NULL;
END;
/
```

**Explanation:**  
- Marks the **end of the PL/SQL block**.  
- `NULL;` is a placeholder to properly terminate the block.  

---

## Example Output

```
--- Starting Batch Audit ---
Processing DEPOSIT for $1000
  -> Status: CLEARED
Processing WITHDRAWAL for $55000
*** AUDIT HALTED ***
Critical Flag: High-value withdrawal detected on Account ACC200
Processing stopped immediately to prevent further automated actions.
```

---

## Conclusion

* This PL/SQL program demonstrates **batch processing using records, collections, and associative arrays**.  
* High-value withdrawals are **flagged and audited** to prevent automated processing of critical transactions.  
* Ensures **efficient, maintainable, and safe transaction auditing**.
