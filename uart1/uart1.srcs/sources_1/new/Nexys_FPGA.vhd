----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2023 01:16:41 PM
-- Design Name: 
-- Module Name: Nexys_FPGA - Behavioral
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

entity Nexys_FPGA is
    Port ( 
           
    
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           rx_tx_switch : in STD_LOGIC;
            
           baud_bits_sw : in STD_LOGIC_VECTOR(2 downto 0);
           start_bit_sw : in STD_LOGIC;
           data_in_sw : in STD_LOGIC_VECTOR (7 downto 0);
           end_bit_sw : in STD_LOGIC;
           
           led_bit_trigger : out STD_LOGIC_VECTOR (7 downto 0);
           led_baud_trigger : out STD_LOGIC_VECTOR (2 downto 0);
           
           info_tx_led : out std_logic_vector (2 downto 0)
            );
           
end Nexys_FPGA;




architecture Behavioral of Nexys_FPGA is
    
    type info_LED is (
        ERROR,
        COMPLETE);
    
    signal parity : std_logic;
    signal sig_LED_Tx : info_LED;
    signal data_bite : std_logic_vector(10 downto 0);
    
    signal data_in : STD_LOGIC_VECTOR (10 downto 0); -- !!!!!!!!!!!!!!
    signal data_out : STD_LOGIC_VECTOR (10 downto 0); -- !!!!!!!!!!!!!!
    
    signal clk_baud : std_logic;
    
    constant c_RED    : std_logic_vector(2 downto 0) := b"100"; -- Bitstream failed 
    constant c_GREEN  : std_logic_vector(2 downto 0) := b"010"; -- Bitstream done



begin


    baud_end0 : entity work.baud
        port map (
            clk => clk,
            rst => rst,
            baud_sw => baud_bits_sw(2 downto 0),
            clk_baud => clk_baud
        );
        
        
   -- transmitter_end0 : entity work.Transmitter
   --     port map (
   --         
   --     );
        
        
    
    baud_led : process(baud_bits_sw) is
    begin
        led_baud_trigger <= baud_bits_sw;
    end process baud_led;
        
        
    nexys_transmitter : process(data_in, rst, rx_tx_switch) is
    begin
        if (rx_tx_switch = '0') then
            parity <= not(data_in(1) xor data_in(2) xor data_in(3) xor data_in(4) xor data_in(5) xor data_in(6) xor data_in(7) xor data_in(8));
        
            if (data_in(9) = parity) then
                if (rst = '1') then
                    led_bit_trigger <= "11111111";
                else
                    led_bit_trigger <= data_in(8 downto 1);
                end if;
                sig_LED_Tx <= COMPLETE;
            else
                sig_LED_Tx <= ERROR;
            end if;
          end if;
    end process nexys_transmitter;
    
    
    
    
    nexys_reciever : process(clk_baud, rx_tx_switch) is
    begin
        if (rx_tx_switch = '1') then
            if (clk_baud = '1') then
               parity <= not(data_in_sw(0) xor data_in_sw(1) xor data_in_sw(2) xor data_in_sw(3) xor data_in_sw(4) xor data_in_sw(5) xor data_in_sw(6) xor data_in_sw(7));
              data_bite <= start_bit_sw & data_in_sw & parity & end_bit_sw;
            end if;
        end if;
    end process nexys_reciever;
    
    
    
    
    LED_control : process (sig_LED_Tx) is
    begin
        case sig_LED_TX is
            when ERROR =>
                info_tx_led <= c_RED;
            when COMPLETE =>
                info_tx_led <= c_GREEN;
        end case;
    end process LED_control;

end Behavioral;
