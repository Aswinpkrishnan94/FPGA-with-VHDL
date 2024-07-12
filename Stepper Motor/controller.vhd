library ieee;
use ieee.std_logic_1164.all;

entity stepper_motor_controller is
port(
		clk, rst		: in std_logic;
		a, d			: in std_logic_vector(1 downto 0);
		b, c, dir	: in std_logic;
		q				: out std_logic_vector(3 downto 0)
    );
end entity;

architecture beh of stepper_motor_controller is

component speed_control
port(
		clk, rst		: in std_logic;
		a			: in std_logic_vector(1 downto 0);
		clk_out		: out std_logic
	  );
end component;

component position_controller 
port(
		b, clk_out	: in std_logic;
		d				: in std_logic_vector(1 downto 0);
		clk_out_cp	: out std_logic
	 );
end component;

component mux21_sp 
port(
		clk_out_sp, clk_out_cp, c   : in std_logic;
		clk_sp_cp						 : out std_logic
	 );
end component;

component clk_div
port(
		clk_in, rst	: in std_logic;
		clk_out		: out std_logic
	 );
end component;

component stepper_motor_full
port(
		clk, rst, dir : in std_logic;
		q				  : out std_logic_vector(3 downto 0)
	 );
end component;

signal s1, s2, s3, s4 : std_logic;

begin

uut1: position_controller port map(b,s1,d, s2);
uut2: speed_control port map(clk, rst, a, s1);
uut3: stepper_motor_full port map(s4, rst, dir, q);
uut4: mux21_sp port map(s3, s2, c, s4);
uut5: clk_div port map(s1, s3);
end beh;	 
