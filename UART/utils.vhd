library ieee;
use ieee.std_logic_1164.all;

package utils is
    function xor_reduce(input : std_logic_vector) return std_logic;
end package;

package body utils is
    function xor_reduce(input : std_logic_vector) return std_logic is
        variable result : std_logic := '0';
    begin
        for i in input'range loop
            result := result xor input(i);
        end loop;
        return result;
    end function;
end package body;
