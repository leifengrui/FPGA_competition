-- Created by IP Generator (Version 2021.1-SP7 build 86875)
-- Instantiation Template
--
-- Insert the following codes into your VHDL file.
--   * Change the_instance_name to your own instance name.
--   * Change the net names in the port map.


COMPONENT sys_pll
  PORT (
    clkout0 : OUT STD_LOGIC;
    lock : OUT STD_LOGIC;
    clkin1 : IN STD_LOGIC;
    rst : IN STD_LOGIC
  );
END COMPONENT;


the_instance_name : sys_pll
  PORT MAP (
    clkout0 => clkout0,
    lock => lock,
    clkin1 => clkin1,
    rst => rst
  );
