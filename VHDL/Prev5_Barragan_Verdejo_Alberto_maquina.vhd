-- AND2 --
ENTITY and2 IS
PORT (a, b: IN BIT; z: OUT BIT);
END and2;

ARCHITECTURE logica_retard of and2 IS
BEGIN
z <= a AND b AFTER 4 ns;
END logica_retard;

-- XNOR2 --
ENTITY xor2 IS
PORT (a, b: IN BIT; z: OUT BIT);
END xor2;

ARCHITECTURE logica_retard OF xor2 IS
BEGIN
z <= a XOR b AFTER 4 ns;
END logica_retard;

-- INVERSOR --
ENTITY inv IS
PORT (a: IN BIT; z: OUT BIT);
END inv;

ARCHITECTURE logica_retard OF inv IS
BEGIN
z <= NOT a AFTER 4 ns;
END logica_retard;

-- Flip Flop JK --
ENTITY FF_JK IS
PORT (J, K, Ck, Clr, Prst: IN BIT; Q, nQ: OUT BIT);
END FF_JK;

ARCHITECTURE ifthen OF FF_JK IS
SIGNAL qint: BIT;
BEGIN
	PROCESS (J, K, Ck, Clr, Prst)
	BEGIN
		IF Clr = '0' THEN qint <= '0' AFTER 4 ns;
		ELSE
			IF Prst = '1' THEN qint <= '1' AFTER 4 ns;
			ELSE
				IF Ck'EVENT AND Ck = '1' THEN
					IF    J = '0' AND K = '0' THEN qint <= qint     AFTER 4 ns;
					ELSIF J = '0' AND K = '1' THEN qint <= '0'      AFTER 4 ns;
					ELSIF J = '1' AND K = '0' THEN qint <= '1'      AFTER 4 ns;
					ELSIF J = '1' AND K = '1' THEN qint <= NOT qint AFTER 4 ns;
					END IF;
				END IF;
			END IF;
		END IF;
	END PROCESS;
Q <= qint; nQ <= NOT qint;
END ifthen;

-- Circuit --
ENTITY circuit IS
PORT (clock, X: IN BIT; Z2,Z1,Z0: OUT BIT);
END circuit;

ARCHITECTURE structural OF circuit IS

COMPONENT and2
PORT (a, b: IN BIT; z : OUT BIT);
END COMPONENT;

COMPONENT xor2
PORT (a, b: IN BIT; z : OUT BIT);
END COMPONENT;

COMPONENT inversor
PORT (a: IN BIT; z : OUT BIT);
END COMPONENT;

COMPONENT FF_JK
PORT (j, k, ck, clr, prst: IN BIT; Q, nQ: OUT BIT);
END COMPONENT;
SIGNAL s_xor, s_inv, s_and, q2, q1, q0: BIT;

FOR DUT1: FF_JK    USE ENTITY WORK.FF_JK    (ifthen);
FOR DUT2: FF_JK    USE ENTITY WORK.FF_JK    (ifthen);
FOR DUT3: FF_JK    USE ENTITY WORK.FF_JK    (ifthen);
FOR DUT4: and2     USE ENTITY WORK.and2     (logica_retard);
FOR DUT5: inversor USE ENTITY WORK.inv      (logica_retard);
FOR DUT6: xor2     USE ENTITY WORK.xor2     (logica_retard);

BEGIN
DUT6:xor2     PORT MAP (X,q2,s_xor);
DUT5:inversor PORT MAP (s_xor,s_inv);
DUT4:and2     PORT MAP (s_inv,q1,s_and);

DUT1:FF_JK    PORT MAP (s_and,s_and,clock,'1','0',q2);
DUT2:FF_JK    PORT MAP (s_inv,s_inv,clock,'1','0',q1);
DUT3:FF_JK    PORT MAP (X,'1',clock,'1','0',q0);

Z2 <= q2;
Z1 <= q1;
Z0 <= q0;
END structural;

-- BANCO DE PRUEBAS --
ENTITY banco_pruebas IS
END banco_pruebas;

ARCHITECTURE test OF banco_pruebas IS

COMPONENT bloque IS
PORT (X, clock: IN BIT; Z0, Z1, Z2: OUT BIT);
END COMPONENT;

SIGNAL X, clock, Z0, Z1, Z2: BIT;
FOR DUT1: bloque USE ENTITY WORK.circuit(structural);

BEGIN
DUT1: bloque PORT MAP (X, clock, Z2, Z1, Z0);

PROCESS (X, clock)
BEGIN
X <= NOT X AFTER 100 ns;
clock <= NOT clock AFTER 50 ns;
END PROCESS;
END test; 