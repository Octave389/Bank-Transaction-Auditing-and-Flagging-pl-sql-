SET SERVEROUTPUT ON;

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

BEGIN
    v_transaction_types('W') := 'WITHDRAWAL';
    v_transaction_types('D') := 'DEPOSIT';
    v_transaction_types('T') := 'TRANSFER';

    v_batch := t_transaction_batch(
        t_transaction_rec('ACC100', 'D', 1000, NULL),
        t_transaction_rec('ACC200', 'W', 55000, NULL),
        t_transaction_rec('ACC300', 'T', 500, NULL)
    );

    DBMS_OUTPUT.PUT_LINE('--- Starting Batch Audit ---');

    FOR i IN 1 .. v_batch.COUNT LOOP
        v_current_transaction := v_batch(i);

        DBMS_OUTPUT.PUT_LINE('Processing ' || v_transaction_types(v_current_transaction.transaction_type_code) ||
                             ' for $' || v_current_transaction.amount);

        IF v_current_transaction.transaction_type_code = 'W' AND v_current_transaction.amount > c_high_value_limit THEN
            v_current_transaction.status := 'FLAGGED FOR REVIEW';
            GOTO CRITICAL_AUDIT_HALT;
        ELSE
            v_current_transaction.status := 'CLEARED';
        END IF;

        DBMS_OUTPUT.PUT_LINE('  -> Status: ' || v_current_transaction.status);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Batch Audit Complete: All transactions cleared. ---');
    GOTO END_PROCEDURE;

<<CRITICAL_AUDIT_HALT>>
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '*** AUDIT HALTED ***');
    DBMS_OUTPUT.PUT_LINE('Critical Flag: High-value withdrawal detected on Account ' || v_current_transaction.account_number);
    DBMS_OUTPUT.PUT_LINE('Processing stopped immediately to prevent further automated actions.');

<<END_PROCEDURE>>
    NULL;

END;
/
