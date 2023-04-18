----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2023 01:10:52 PM
-- Design Name: 
-- Module Name: UART - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UART is
    port (
    CLK100MHZ : in    std_logic;
    SW        : in    std_logic_vector(15 downto 0);
    BTNC      : in    std_logic;
    
    LED16_R   : out   std_logic; -- Left Red
    LED16_G   : out   std_logic; -- Left Green
    LED16_Y   : out   std_logic; -- Left Yellow
    LED17_R   : out   std_logic; -- Right Red
    LED17_G   : out   std_logic; -- Right Green
    LED17_Y   : out   std_logic; -- Right Yellow
    
    LED       : out   std_logic_vector(15 downto 0) -- Bit reciever LED-information
    );
end UART;

architecture Behavioral of UART is

begin

    Nexys_led : entity work.Nexys_FPGA
        port map (
        
        clk => CLK100MHZ,
        rst => BTNC,
        rx_tx_switch => SW(12),
        
        baud_bits_sw => SW(15 downto 13),
        
        start_bit_sw => SW(0),
        data_in_sw => SW(8 downto 1),
        end_bit_sw => SW(9),
        
        led_bit_trigger => LED(8 downto 1),
        
        led_baud_trigger => LED(15 downto 13),
        
        info_tx_led(2) => LED16_R,
        info_tx_led(1) => LED16_G,
        info_tx_led(0) => LED16_Y
        );

   -- reciever_end0 : entity work.Reciever
   --     port map (
   --     
   --     );

end Behavioral;
