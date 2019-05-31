-- INVERSOR --
ENTITY inv IS
PORT (a: IN BIT; z: OUT BIT);
END inv;

ARCHITECTURE logica_retard OF inv IS
BEGIN
z <= NOT a AFTER 3 ns;
END logica_retard;

-- AND2 --
ENTITY and2 IS
PORT (a, b: IN BIT; z: OUT BIT);
END and2;

ARCHITECTURE logica_retard of and2 IS
BEGIN
z <= a AND b AFTER 3 ns;
END logica_retard;

-- NOR2 --
ENTITY nor2 IS
PORT (a, b: IN BIT; z: OUT BIT);
END nor2;

ARCHITECTURE logica_retard OF nor2 IS
BEGIN
z <= a NOR b AFTER 3 ns;
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
		IF Clr = '0' THEN qint <= '0' AFTER 3 ns;
		ELSE
			IF Prst = '1' THEN qint <= '1' AFTER 3 ns;
			ELSE
				IF Ck'EVENT AND Ck = '1' THEN
					IF    J = '0' AND K = '0' THEN qint <= qint     AFTER 3 ns;
					ELSIF J = '0' AND K = '1' THEN qint <= '0'      AFTER 3 ns;
					ELSIF J = '1' AND K = '0' THEN qint <= '1'      AFTER 3 ns;
					ELSIF J = '1' AND K = '1' THEN qint <= NOT qint AFTER 3 ns;
					END IF;
				END IF;
			END IF;
		END IF;
	END PROCESS;
Q <= qint; nQ <= NOT qint;
END ifthen;

ARCHITECTURE ifthen_nClr_nPrst OF FF_JK IS
SIGNAL qint: BIT;
BEGIN
	PROCESS (J, K, Ck, Clr, Prst)
	BEGIN
		IF Ck'EVENT AND Ck = '1' THEN
			IF    J = '0' AND K = '0' THEN qint <= qint     AFTER 3 ns;
			ELSIF J = '0' AND K = '1' THEN qint <= '0'      AFTER 3 ns;
			ELSIF J = '1' AND K = '0' THEN qint <= '1'      AFTER 3 ns;
			ELSIF J = '1' AND K = '1' THEN qint <= NOT qint AFTER 3 ns;
			END IF;
		END IF;
	END PROCESS;
Q <= qint; nQ <= NOT qint;
END ifthen_nClr_nPrst;

-- Latch D --
ENTITY LatchD IS
PORT (S, R, Clr, Prst: IN BIT; Q, nQ: OUT BIT);
END LatchD;


ARCHITECTURE ifthen OF LatchD IS
SIGNAL qint: BIT;
BEGIN
	PROCESS (S, R, Clr, Prst)
	BEGIN
		IF Clr = '0' THEN qint <= '0' AFTER 3 ns;
		ELSE
			IF Prst = '1' THEN qint <= '1' AFTER 3 ns;
			ELSE
				IF S = '0' THEN qint <= qint AFTER 3 ns;
				ELSIF S = '1' AND R = '0' THEN qint <= '0' AFTER 3 ns;
				ELSIF S = '1' AND R = '1' THEN qint <= '1' AFTER 3 ns;
				END IF;
			END IF;
		END IF;
	END PROCESS;
Q <= qint; nQ <= NOT qint;
END ifthen;

ARCHITECTURE ifthen_nClr_nPrst OF LatchD IS
SIGNAL qint: BIT;
BEGIN
	PROCESS (S, R, Clr, Prst)
	BEGIN
		IF S = '0' THEN qint <= qint AFTER 3 ns;
		ELSIF S = '1' AND R = '0' THEN qint <= '0' AFTER 3 ns;
		ELSIF S = '1' AND R = '1' THEN qint <= '1' AFTER 3 ns;
		END IF;
	END PROCESS;
Q <= qint; nQ <= NOT qint;
END ifthen_nClr_nPrst;

-- Banco de Pruebas para los componentes --	
ENTITY banc_proves IS
END banc_proves;

ARCHITECTURE test OF banc_proves IS
COMPONENT inv IS
PORT(a:IN BIT; z:OUT BIT);
END COMPONENT;

COMPONENT and2 IS
PORT(a, b:IN BIT; z: OUT BIT);
END COMPONENT; 

COMPONENT nor2 IS
PORT(a, b:IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT FF_JK IS
PORT (J, K, Ck, Clr, Prst: IN BIT; Q, nQ: OUT BIT);
END COMPONENT;

COMPONENT LatchD IS
PORT (S, R, Clr, Prst: IN BIT; Q, nQ: OUT BIT);
END COMPONENT;

FOR DUT1: inv    USE ENTITY WORK.inv   (logica_retard);
FOR DUT2: and2   USE ENTITY WORK.and2  (logica_retard);
FOR DUT3: nor2   USE ENTITY WORK.nor2  (logica_retard);
FOR DUT4: FF_JK  USE ENTITY WORK.FF_JK (ifthen);
FOR DUT5: LatchD USE ENTITY WORK.LatchD(ifthen);
-- Señales a y b de entrad para todos y extra Clock y clear preset solo para FF y Latch
SIGNAL a, b, clock, clear, preset, sal_inv, sal_and2, sal_nor2, sal_FF, noSal_FF, sal_Latch, noSal_Latch: BIT;

BEGIN

DUT1: inv    PORT MAP(a, sal_inv);
DUT2: and2   PORT MAP(a, b, sal_and2);
DUT3: nor2   PORT MAP(a, b, sal_nor2);
DUT4: FF_JK  PORT MAP(a, b, clock, clear, preset, sal_FF, noSal_FF);
DUT5: LatchD PORT MAP(a, b, clear, preset, sal_Latch, noSal_Latch);

PROCESS(a,b,clock,clear,preset)
BEGIN
	a      <= NOT a      AFTER 50 ns;
	b      <= NOT b      AFTER 100 ns;
	clock  <= NOT clock  AFTER 200 ns;
	clear  <= NOT clear  AFTER 400 ns;
	preset <= NOT preset AFTER 800 ns;
END PROCESS;
END test;


-- CIRCUITO PREGUNTA 3 --
ENTITY circuito IS
PORT (x, Ck: IN BIT; Z, noZ: OUT BIT);
END circuito;

ARCHITECTURE structural OF circuito IS

COMPONENT inv IS
PORT (a: IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT and2 IS
PORT(a, b:IN BIT; z: OUT BIT);
END COMPONENT; 

COMPONENT nor2 IS
PORT(a, b:IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT FF_JK IS
PORT (J, K, Ck, Clr, Prst: IN BIT; Q, nQ: OUT BIT);
END COMPONENT;

COMPONENT LatchD IS
PORT (S, R, Clr, Prst: IN BIT; Q, nQ: OUT BIT);
END COMPONENT;

SIGNAL intq, intNoq, Clr, Prst, notX, sal_and2, sal_nor2: BIT;

FOR DUT1: LatchD USE ENTITY WORK.LatchD(ifthen_nClr_nPrst);
FOR DUT2: inv    USE ENTITY WORK.inv   (logica_retard);
FOR DUT3: and2   USE ENTITY WORK.and2  (logica_retard);
FOR DUT4: nor2   USE ENTITY WORK.nor2  (logica_retard);
FOR DUT5: FF_JK  USE ENTITY WORK.FF_JK (ifthen_nClr_nPrst);

BEGIN
DUT1: LatchD PORT MAP (X, Ck, Clr, Prst, intq, intNoq);
DUT2: inv    PORT MAP (X, notX);
DUT3: and2   PORT MAP (X, intNoq, sal_and2);
DUT4: nor2   PORT MAP (notX, Ck, sal_nor2);
DUT5: FF_JK  PORT MAP (sal_and2, sal_nor2, Ck, Clr, Prst, Z, noZ); -- Ignorar noZ en la simulación pues no es requerido pero lo doy de todos modos


END structural;

-- Banco de pruebas --
ENTITY banc_proves_circuit IS
END banc_proves_circuit;

ARCHITECTURE test OF banc_proves_circuit IS

COMPONENT bloque IS
PORT (X, Ck: IN BIT; Z, noZ: OUT BIT);
END COMPONENT;

SIGNAL X, Ck, Z, noZ: BIT;
FOR DUT1: bloque USE ENTITY WORK.circuito(structural);

BEGIN
DUT1: bloque PORT MAP (X, Ck, Z, noZ);

PROCESS (X, Ck)
BEGIN
X <=  NOT X  AFTER 50 ns;
Ck <= NOT Ck AFTER 100 ns;
END PROCESS;
END test; 