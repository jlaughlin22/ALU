-------------------------------------------------
-- Module Name:    alu - Behavioral 
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu is
   port(
        alusel : in STD_LOGIC_VECTOR(3 downto 0);
        a: in STD_LOGIC_VECTOR(31 downto 0);
        b: in STD_LOGIC_VECTOR(31 downto 0);
        nf: out STD_LOGIC;
        zf: out STD_LOGIC;
        cf: out STD_LOGIC;
        ovf: out STD_LOGIC;
        y : out STD_LOGIC_VECTOR (31 downto 0)
        );
   end alu;

architecture alu of alu is
    begin
        process(a,b,alusel)
        variable temp: STD_LOGIC_VECTOR(32 downto 0);
        variable yv: STD_LOGIC_VECTOR(31 downto 0);
        variable cfv,zfv: STD_LOGIC;
        variable tempa: STD_LOGIC_VECTOR(15 downto 0);
        variable tempb: STD_LOGIC_VECTOR(15 downto 0);
        begin
        cf <= '0';
        ovf <= '0';
        temp := "000000000000000000000000000000000";
        zfv := '0';
        case alusel is
            when "0000" =>
                yv := not a;
            when "0001" =>
                yv := a and b;
            when "0010" =>
                yv := a or b;
            when "0011" =>
                yv := a xor b;
            when "0100" =>
                yv := a nor b;
            when "0101" =>
                temp := ('0' & a ) - ('0' & b);
                cfv := temp(32);
                if cfv = '0' then
                    yv := "00000000000000000000000000000001";
                else
                    yv := "00000000000000000000000000000000";
                end if;
            when "0110" =>
                temp := ('0' & a ) - ('0' & b);
                cfv := temp(32);
                if cfv = '1' then
                    yv := "00000000000000000000000000000001";
                else
                    yv := "00000000000000000000000000000000";
                end if;
            when "0111" =>
                temp := ('0' & a ) - ('0' & b);
                cfv := temp(32);
                if a = b then
                    yv := "00000000000000000000000000000001";
                else 
                    if cfv = '0' then 
                        yv := "00000000000000000000000000000001";
                    else 
                        yv := "00000000000000000000000000000000";
                    end if;
                end if;
            when "1000" =>
                temp := ('0' & a ) - ('0' & b);
                cfv := temp(32);
                if a = b then
                    yv := "00000000000000000000000000000001";
                else 
                    if cfv = '1' then 
                        yv := "00000000000000000000000000000001";
                    else 
                        yv := "00000000000000000000000000000000";
                    end if;
                end if;
            when "1001" =>
                if a = b then
                    yv := "00000000000000000000000000000001";
                else
                    yv := "00000000000000000000000000000000";
                end if;
            
            when "1010" =>
                temp := ('0' & a ) + ('0' & b);
                yv := temp (31 downto 0);
                cfv := temp(32);
                ovf <= yv(31) xor a (31) xor b(31) xor cfv;
                cf <= cfv;
            when "1011" =>
                temp := ('0' & a ) - ('0' & b);
                yv := temp (31 downto 0);
                cfv := temp(32);
                ovf <= yv(31) xor a (31) xor b(31) xor cfv;
                cf <= cfv;
            when "1100" =>
                 tempa:= a(15 downto 0);
                 tempb:= b(15 downto 0);
                 yv := tempa * tempb;
                 
            when others =>
                yv := a;
            end case;

            if (yv = "00000000000000000000000000000000") then 
                zf <= '1';
            else
                zf <= '0';
            end if;
            y <= yv;
            nf <= yv(3);
    end process;

end alu;
