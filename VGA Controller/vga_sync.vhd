library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_sync is
port(
		clk, rst		 	   : in std_logic;
		hsync, vsync		: out std_logic;
		video_on, p_tick	: out std_logic;
		pixel_x, pixel_y  : out std_logic_vector(9 downto 0)
	);
end entity;

architecture beh of vga_sync is

-- constant 640x480 parameters
constant hd	: integer := 640;		-- horizontal display area
constant hf	: integer := 16;		-- horizontal front porch
constant hb : integer := 48;		-- horizontal back porch
constant hr : integer := 96;		-- retrace
constant vd : integer := 480;		-- vertical display area
constant vf	: integer := 10;		-- vertical front porch
constant vb	: integer := 33;		-- vertical back porch
constant vr : integer := 2;		-- retrace

-- mod 2 counter. for 25 MHz counter
signal mod2ctr_reg, mod2ctr_next : std_logic;

-- sync counter
signal v_count_reg, v_count_next : unsigned(9 downto 0);
signal h_count_reg, h_count_next : unsigned(9 downto 0);

-- output buffer
signal v_sync_reg, v_sync_next : std_logic;
signal h_sync_reg, h_sync_next : std_logic;

-- status signal
signal v_end, h_end, pixel_tick	: std_logic;

begin

process(clk, rst)
begin

if(rst = '1') then
	mod2ctr_reg <= '0';
	v_count_reg <= (others =>'0');
	h_count_reg <= (others =>'0');
	v_sync_reg  <= '0';
	h_sync_reg  <= '0';
	
elsif(clk = '1' and clk'EVENT) then
	mod2ctr_reg <= mod2ctr_next;
	v_count_reg <= v_count_next;
	h_count_reg <= h_count_next;
	v_sync_reg  <= v_sync_next;
	h_sync_reg  <= h_sync_next;
	
end if;
end process;

-- to generate 25 MHz clock tick
mod2ctr_next <= not mod2ctr_reg;

pixel_tick <= '1' when mod2ctr_reg = '1' else '0';	-- 25 MHz pixel tick

--status
h_end <= '1' when h_count_reg = (hd+hf+hb+hr-1) else '0';	--799
v_end <= '1' when v_count_reg = (vd+vf+vb+vr-1) else '0'; -- 524

-- mod 800 counter
process(h_count_reg, pixel_tick, h_end)
begin

if(pixel_tick = '1') then
	if(h_end = '1') then
		h_count_next <= (others => '0');
	else
		h_count_next <= h_count_reg + 1;
	end if;
else
	h_count_next <= h_count_reg;

	end if;
end process;

-- mod 525 counter
process(v_count_reg, pixel_tick, v_end)
begin

if(pixel_tick = '1') then
	if(v_end = '1') then
		v_count_next <= (others => '0');
	else
		v_count_next <= v_count_reg + 1;
	end if;
else
	v_count_next <= v_count_reg;

	end if;
end process;

-- horizontal and vertical sync
h_sync_next <= '1' when (h_count_reg) >= ((hd+hf))-- greater than 656
						 and (h_count_reg <= ((hd+hf+hr-1))) else  -- greater than 751
					'0';
	
v_sync_next <= '1' when (v_count_reg)>=(vd+vf)	-- greater than 490
						 and (v_count_reg <=(vd+vf+vr-1)) else  -- greater than 491
					'0';	
					
-- video on/off
video_on <= '1' when (h_count_reg < hd) and (v_count_reg < vd) else
				'0';
				
-- output signal
hsync <= h_sync_reg;
vsync <= v_sync_reg;
pixel_x <= std_logic_vector(h_count_reg);
pixel_y <= std_logic_vector(v_count_reg);
p_tick <= pixel_tick;

end beh;
