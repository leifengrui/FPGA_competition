-- Created by IP Generator (Version 2021.1-SP7 build 86875)
-- Instantiation Template
--
-- Insert the following codes into your VHDL file.
--   * Change the_instance_name to your own instance name.
--   * Change the net names in the port map.


COMPONENT Left_FIFO
  PORT (
    wr_data : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    wr_clk : IN STD_LOGIC;
    full : OUT STD_LOGIC;
    wr_rst : IN STD_LOGIC;
    almost_full : OUT STD_LOGIC;
    rd_data : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
    rd_en : IN STD_LOGIC;
    rd_clk : IN STD_LOGIC;
    empty : OUT STD_LOGIC;
    rd_rst : IN STD_LOGIC;
    almost_empty : OUT STD_LOGIC
  );
END COMPONENT;


the_instance_name : Left_FIFO
  PORT MAP (
    wr_data => wr_data,
    wr_en => wr_en,
    wr_clk => wr_clk,
    full => full,
    wr_rst => wr_rst,
    almost_full => almost_full,
    rd_data => rd_data,
    rd_en => rd_en,
    rd_clk => rd_clk,
    empty => empty,
    rd_rst => rd_rst,
    almost_empty => almost_empty
  );
