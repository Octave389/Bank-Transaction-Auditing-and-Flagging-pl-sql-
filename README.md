#  Bank Transaction Auditing and Flagging

## Overview
This project demonstrates a critical security mechanism in banking transaction processing using PL/SQL. The main goal is to process daily transaction batches and immediately halt processing if a high-value withdrawal (over $50,000) is detected, allowing for human review and preventing further automated actions.

In simple terms: every transaction in a batch is checked. If a large withdrawal occurs, the program stops all automated steps and raises an alert.

## Project Goal
Enforce a strict security protocol: instant termination of automated processing upon detection of a high-risk withdrawal ($50,000+).

## Solution Approach
Implemented using PL/SQL **Collections** for batch data, **Records** for individual transaction structure, and the **GOTO** statement for emergency flow control.

## Core PL/SQL Concepts Demonstrated

| Concept | Structure Used | Technical Role |
|---------|----------------|----------------|
| Record | `t_transaction_rec` | Defines a single transaction item, grouping fields like account number, transaction type, and amount. |
| Collection | `t_transaction_batch` | Holds the batch of transactions in memory for processing. |
| GOTO Statement | `GOTO CRITICAL_AUDIT_HALT` | Immediately diverts execution to the alert point, bypassing all remaining logic. |

## Conceptual Data Model
The code uses in-memory data types to simulate interaction with production database tables such as `BANK_TRANSACTIONS` and `AUDIT_LOG`.

## Test Cases and Validation

| Scenario | Transaction | Expected Behavior | Validation Proof |
|----------|------------|------------------|-----------------|
| Normal Flow | T1: Deposit $1,000 | Processed successfully; status = CLEARED | Output shows processing and `-> Status: CLEARED` |
| Trigger Event | T2: Withdrawal $55,000 | Status = FLAGGED FOR REVIEW; GOTO executed | Output jumps immediately to `*** AUDIT HALTED ***`; no final status for T2 |
| Skipped Processing | T3: Transfer $500 | Not processed | No output related to ACC300 |

## Complete PL/SQL Implementation

Before running, enable server output:
```sql
SET SERVEROUTPUT ON;
