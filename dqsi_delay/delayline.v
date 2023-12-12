//  This module combines 44 delay cells as a delay line                                ==//

`timescale 1ns/100ps

module dqsi_delay_line(
    rst_n, test_mode, si, adj, so
);

input           rst_n;
input           test_mode;
input           si;
input   [63:0]  adj;

output          so;

wire            so_t;

wire            si_d0/* synthesis syn_keep=1 */;
wire            si_d1/* synthesis syn_keep=1 */;
wire            si_d2/* synthesis syn_keep=1 */;
wire            si_d3/* synthesis syn_keep=1 */;
wire            si_d4/* synthesis syn_keep=1 */;
wire            si_d5/* synthesis syn_keep=1 */;
wire            si_d6/* synthesis syn_keep=1 */;
wire            si_d7/* synthesis syn_keep=1 */;
wire            si_d8/* synthesis syn_keep=1 */;
wire            si_d9/* synthesis syn_keep=1 */;
wire            si_d10/* synthesis syn_keep=1 */;
wire            si_d11/* synthesis syn_keep=1 */;
wire            si_d12/* synthesis syn_keep=1 */;
wire            si_d13/* synthesis syn_keep=1 */;
wire            si_d14/* synthesis syn_keep=1 */;
wire            si_d15/* synthesis syn_keep=1 */;
wire            si_d16/* synthesis syn_keep=1 */;
wire            si_d17/* synthesis syn_keep=1 */;
wire            si_d18/* synthesis syn_keep=1 */;
wire            si_d19/* synthesis syn_keep=1 */;
wire            si_d20/* synthesis syn_keep=1 */;
wire            si_d21/* synthesis syn_keep=1 */;
wire            si_d22/* synthesis syn_keep=1 */;
wire            si_d23/* synthesis syn_keep=1 */;
wire            si_d24/* synthesis syn_keep=1 */;
wire            si_d25/* synthesis syn_keep=1 */;
wire            si_d26/* synthesis syn_keep=1 */;
wire            si_d27/* synthesis syn_keep=1 */;
wire            si_d28/* synthesis syn_keep=1 */;
wire            si_d29/* synthesis syn_keep=1 */;
wire            si_d30/* synthesis syn_keep=1 */;
wire            si_d31/* synthesis syn_keep=1 */;
wire            si_d32/* synthesis syn_keep=1 */;
wire            si_d33/* synthesis syn_keep=1 */;
wire            si_d34/* synthesis syn_keep=1 */;
wire            si_d35/* synthesis syn_keep=1 */;
wire            si_d36/* synthesis syn_keep=1 */;
wire            si_d37/* synthesis syn_keep=1 */;
wire            si_d38/* synthesis syn_keep=1 */;
wire            si_d39/* synthesis syn_keep=1 */;
wire            si_d40/* synthesis syn_keep=1 */;
wire            si_d41/* synthesis syn_keep=1 */;
wire            si_d42/* synthesis syn_keep=1 */;
wire            si_d43/* synthesis syn_keep=1 */;
wire            si_d44/* synthesis syn_keep=1 */;
wire            si_d45/* synthesis syn_keep=1 */;
wire            si_d46/* synthesis syn_keep=1 */;
wire            si_d47/* synthesis syn_keep=1 */;
wire            si_d48/* synthesis syn_keep=1 */;
wire            si_d49/* synthesis syn_keep=1 */;
wire            si_d50/* synthesis syn_keep=1 */;
wire            si_d51/* synthesis syn_keep=1 */;
wire            si_d52/* synthesis syn_keep=1 */;
wire            si_d53/* synthesis syn_keep=1 */;
wire            si_d54/* synthesis syn_keep=1 */;
wire            si_d55/* synthesis syn_keep=1 */;
wire            si_d56/* synthesis syn_keep=1 */;
wire            si_d57/* synthesis syn_keep=1 */;
wire            si_d58/* synthesis syn_keep=1 */;
wire            si_d59/* synthesis syn_keep=1 */;
wire            si_d60/* synthesis syn_keep=1 */;
wire            si_d61/* synthesis syn_keep=1 */;
wire            si_d62/* synthesis syn_keep=1 */;
wire            si_d63/* synthesis syn_keep=1 */;
wire            si_d64/* synthesis syn_keep=1 */;

wire            so/* synthesis syn_keep=1 */;
wire            so1/* synthesis syn_keep=1 */;
wire            so2/* synthesis syn_keep=1 */;
wire            so3/* synthesis syn_keep=1 */;
wire            so4/* synthesis syn_keep=1 */;
wire            so5/* synthesis syn_keep=1 */;
wire            so6/* synthesis syn_keep=1 */;
wire            so7/* synthesis syn_keep=1 */;
wire            so8/* synthesis syn_keep=1 */;
wire            so9/* synthesis syn_keep=1 */;
wire            so10/* synthesis syn_keep=1 */;
wire            so11/* synthesis syn_keep=1 */;
wire            so12/* synthesis syn_keep=1 */;
wire            so13/* synthesis syn_keep=1 */;
wire            so14/* synthesis syn_keep=1 */;
wire            so15/* synthesis syn_keep=1 */;
wire            so16/* synthesis syn_keep=1 */;
wire            so17/* synthesis syn_keep=1 */;
wire            so18/* synthesis syn_keep=1 */;
wire            so19/* synthesis syn_keep=1 */;
wire            so20/* synthesis syn_keep=1 */;
wire            so21/* synthesis syn_keep=1 */;
wire            so22/* synthesis syn_keep=1 */;
wire            so23/* synthesis syn_keep=1 */;
wire            so24/* synthesis syn_keep=1 */;
wire            so25/* synthesis syn_keep=1 */;
wire            so26/* synthesis syn_keep=1 */;
wire            so27/* synthesis syn_keep=1 */;
wire            so28/* synthesis syn_keep=1 */;
wire            so29/* synthesis syn_keep=1 */;
wire            so30/* synthesis syn_keep=1 */;
wire            so31/* synthesis syn_keep=1 */;
wire            so32/* synthesis syn_keep=1 */;
wire            so33/* synthesis syn_keep=1 */;
wire            so34/* synthesis syn_keep=1 */;
wire            so35/* synthesis syn_keep=1 */;
wire            so36/* synthesis syn_keep=1 */;
wire            so37/* synthesis syn_keep=1 */;
wire            so38/* synthesis syn_keep=1 */;
wire            so39/* synthesis syn_keep=1 */;
wire            so40/* synthesis syn_keep=1 */;
wire            so41/* synthesis syn_keep=1 */;
wire            so42/* synthesis syn_keep=1 */;
wire            so43/* synthesis syn_keep=1 */;
wire            so44/* synthesis syn_keep=1 */;
wire            so45/* synthesis syn_keep=1 */;
wire            so46/* synthesis syn_keep=1 */;
wire            so47/* synthesis syn_keep=1 */;
wire            so48/* synthesis syn_keep=1 */;
wire            so49/* synthesis syn_keep=1 */;
wire            so50/* synthesis syn_keep=1 */;
wire            so51/* synthesis syn_keep=1 */;
wire            so52/* synthesis syn_keep=1 */;
wire            so53/* synthesis syn_keep=1 */;
wire            so54/* synthesis syn_keep=1 */;
wire            so55/* synthesis syn_keep=1 */;
wire            so56/* synthesis syn_keep=1 */;
wire            so57/* synthesis syn_keep=1 */;
wire            so58/* synthesis syn_keep=1 */;
wire            so59/* synthesis syn_keep=1 */;
wire            so60/* synthesis syn_keep=1 */;
wire            so61/* synthesis syn_keep=1 */;
wire            so62/* synthesis syn_keep=1 */;
wire            so63/* synthesis syn_keep=1 */;

reg             adj0/* synthesis syn_keep=1 */;
reg             adj1/* synthesis syn_keep=1 */;
reg             adj2/* synthesis syn_keep=1 */;
reg             adj3/* synthesis syn_keep=1 */;
reg             adj4/* synthesis syn_keep=1 */;
reg             adj5/* synthesis syn_keep=1 */;
reg             adj6/* synthesis syn_keep=1 */;
reg             adj7/* synthesis syn_keep=1 */;
reg             adj8/* synthesis syn_keep=1 */;
reg             adj9/* synthesis syn_keep=1 */;
reg             adj10/* synthesis syn_keep=1 */;
reg             adj11/* synthesis syn_keep=1 */;
reg             adj12/* synthesis syn_keep=1 */;
reg             adj13/* synthesis syn_keep=1 */;
reg             adj14/* synthesis syn_keep=1 */;
reg             adj15/* synthesis syn_keep=1 */;
reg             adj16/* synthesis syn_keep=1 */;
reg             adj17/* synthesis syn_keep=1 */;
reg             adj18/* synthesis syn_keep=1 */;
reg             adj19/* synthesis syn_keep=1 */;
reg             adj20/* synthesis syn_keep=1 */;
reg             adj21/* synthesis syn_keep=1 */;
reg             adj22/* synthesis syn_keep=1 */;
reg             adj23/* synthesis syn_keep=1 */;
reg             adj24/* synthesis syn_keep=1 */;
reg             adj25/* synthesis syn_keep=1 */;
reg             adj26/* synthesis syn_keep=1 */;
reg             adj27/* synthesis syn_keep=1 */;
reg             adj28/* synthesis syn_keep=1 */;
reg             adj29/* synthesis syn_keep=1 */;
reg             adj30/* synthesis syn_keep=1 */;
reg             adj31/* synthesis syn_keep=1 */;
reg             adj32/* synthesis syn_keep=1 */;
reg             adj33/* synthesis syn_keep=1 */;
reg             adj34/* synthesis syn_keep=1 */;
reg             adj35/* synthesis syn_keep=1 */;
reg             adj36/* synthesis syn_keep=1 */;
reg             adj37/* synthesis syn_keep=1 */;
reg             adj38/* synthesis syn_keep=1 */;
reg             adj39/* synthesis syn_keep=1 */;
reg             adj40/* synthesis syn_keep=1 */;
reg             adj41/* synthesis syn_keep=1 */;
reg             adj42/* synthesis syn_keep=1 */;
reg             adj43/* synthesis syn_keep=1 */;
reg             adj44/* synthesis syn_keep=1 */;
reg             adj45/* synthesis syn_keep=1 */;
reg             adj46/* synthesis syn_keep=1 */;
reg             adj47/* synthesis syn_keep=1 */;
reg             adj48/* synthesis syn_keep=1 */;
reg             adj49/* synthesis syn_keep=1 */;
reg             adj50/* synthesis syn_keep=1 */;
reg             adj51/* synthesis syn_keep=1 */;
reg             adj52/* synthesis syn_keep=1 */;
reg             adj53/* synthesis syn_keep=1 */;
reg             adj54/* synthesis syn_keep=1 */;
reg             adj55/* synthesis syn_keep=1 */;
reg             adj56/* synthesis syn_keep=1 */;
reg             adj57/* synthesis syn_keep=1 */;
reg             adj58/* synthesis syn_keep=1 */;
reg             adj59/* synthesis syn_keep=1 */;
reg             adj60/* synthesis syn_keep=1 */;
reg             adj61/* synthesis syn_keep=1 */;
reg             adj62/* synthesis syn_keep=1 */;
reg             adj63/* synthesis syn_keep=1 */;

`ifdef fsh_sim
    assign  so = so_t;
`else
    `ifdef fpga
        MUXCY dnth_u_dline64_so(.DI(so_t), .CI(si), .S(test_mode), .O(so));
    `else
        mux2x1 dnth_u_dline64_so(.A(so_t), .B(si), .S(test_mode), .O(so));
    `endif

`endif

//===== Delay line chain =====//
//===== This chain at least exists one level delay (dly0) =====//
flash_delay_cell dly0(.si(si), .nxt_en(adj0), .si_nxt(so1), .so(so_t), .so_nxt(si_d0));
flash_delay_cell dly1(.si(si_d0), .nxt_en(adj1), .si_nxt(so2), .so(so1), .so_nxt(si_d1));
flash_delay_cell dly2(.si(si_d1), .nxt_en(adj2), .si_nxt(so3), .so(so2), .so_nxt(si_d2));
flash_delay_cell dly3(.si(si_d2), .nxt_en(adj3), .si_nxt(so4), .so(so3), .so_nxt(si_d3));
flash_delay_cell dly4(.si(si_d3), .nxt_en(adj4), .si_nxt(so5), .so(so4), .so_nxt(si_d4));
flash_delay_cell dly5(.si(si_d4), .nxt_en(adj5), .si_nxt(so6), .so(so5), .so_nxt(si_d5));
flash_delay_cell dly6(.si(si_d5), .nxt_en(adj6), .si_nxt(so7), .so(so6), .so_nxt(si_d6));
flash_delay_cell dly7(.si(si_d6), .nxt_en(adj7), .si_nxt(so8), .so(so7), .so_nxt(si_d7));
flash_delay_cell dly8(.si(si_d7), .nxt_en(adj8), .si_nxt(so9), .so(so8), .so_nxt(si_d8));
flash_delay_cell dly9(.si(si_d8), .nxt_en(adj9), .si_nxt(so10), .so(so9), .so_nxt(si_d9));
flash_delay_cell dly10(.si(si_d9), .nxt_en(adj10), .si_nxt(so11), .so(so10), .so_nxt(si_d10));
flash_delay_cell dly11(.si(si_d10), .nxt_en(adj11), .si_nxt(so12), .so(so11), .so_nxt(si_d11));
flash_delay_cell dly12(.si(si_d11), .nxt_en(adj12), .si_nxt(so13), .so(so12), .so_nxt(si_d12));
flash_delay_cell dly13(.si(si_d12), .nxt_en(adj13), .si_nxt(so14), .so(so13), .so_nxt(si_d13));
flash_delay_cell dly14(.si(si_d13), .nxt_en(adj14), .si_nxt(so15), .so(so14), .so_nxt(si_d14));
flash_delay_cell dly15(.si(si_d14), .nxt_en(adj15), .si_nxt(so16), .so(so15), .so_nxt(si_d15));
flash_delay_cell dly16(.si(si_d15), .nxt_en(adj16), .si_nxt(so17), .so(so16), .so_nxt(si_d16));
flash_delay_cell dly17(.si(si_d16), .nxt_en(adj17), .si_nxt(so18), .so(so17), .so_nxt(si_d17));
flash_delay_cell dly18(.si(si_d17), .nxt_en(adj18), .si_nxt(so19), .so(so18), .so_nxt(si_d18));
flash_delay_cell dly19(.si(si_d18), .nxt_en(adj19), .si_nxt(so20), .so(so19), .so_nxt(si_d19));
flash_delay_cell dly20(.si(si_d19), .nxt_en(adj20), .si_nxt(so21), .so(so20), .so_nxt(si_d20));
flash_delay_cell dly21(.si(si_d20), .nxt_en(adj21), .si_nxt(so22), .so(so21), .so_nxt(si_d21));
flash_delay_cell dly22(.si(si_d21), .nxt_en(adj22), .si_nxt(so23), .so(so22), .so_nxt(si_d22));
flash_delay_cell dly23(.si(si_d22), .nxt_en(adj23), .si_nxt(so24), .so(so23), .so_nxt(si_d23));
flash_delay_cell dly24(.si(si_d23), .nxt_en(adj24), .si_nxt(so25), .so(so24), .so_nxt(si_d24));
flash_delay_cell dly25(.si(si_d24), .nxt_en(adj25), .si_nxt(so26), .so(so25), .so_nxt(si_d25));
flash_delay_cell dly26(.si(si_d25), .nxt_en(adj26), .si_nxt(so27), .so(so26), .so_nxt(si_d26));
flash_delay_cell dly27(.si(si_d26), .nxt_en(adj27), .si_nxt(so28), .so(so27), .so_nxt(si_d27));
flash_delay_cell dly28(.si(si_d27), .nxt_en(adj28), .si_nxt(so29), .so(so28), .so_nxt(si_d28));
flash_delay_cell dly29(.si(si_d28), .nxt_en(adj29), .si_nxt(so30), .so(so29), .so_nxt(si_d29));
flash_delay_cell dly30(.si(si_d29), .nxt_en(adj30), .si_nxt(so31), .so(so30), .so_nxt(si_d30));
flash_delay_cell dly31(.si(si_d30), .nxt_en(adj31), .si_nxt(so32), .so(so31), .so_nxt(si_d31));
flash_delay_cell dly32(.si(si_d31), .nxt_en(adj32), .si_nxt(so33), .so(so32), .so_nxt(si_d32));
flash_delay_cell dly33(.si(si_d32), .nxt_en(adj33), .si_nxt(so34), .so(so33), .so_nxt(si_d33));
flash_delay_cell dly34(.si(si_d33), .nxt_en(adj34), .si_nxt(so35), .so(so34), .so_nxt(si_d34));
flash_delay_cell dly35(.si(si_d34), .nxt_en(adj35), .si_nxt(so36), .so(so35), .so_nxt(si_d35));
flash_delay_cell dly36(.si(si_d35), .nxt_en(adj36), .si_nxt(so37), .so(so36), .so_nxt(si_d36));
flash_delay_cell dly37(.si(si_d36), .nxt_en(adj37), .si_nxt(so38), .so(so37), .so_nxt(si_d37));
flash_delay_cell dly38(.si(si_d37), .nxt_en(adj38), .si_nxt(so39), .so(so38), .so_nxt(si_d38));
flash_delay_cell dly39(.si(si_d38), .nxt_en(adj39), .si_nxt(so40), .so(so39), .so_nxt(si_d39));
flash_delay_cell dly40(.si(si_d39), .nxt_en(adj40), .si_nxt(so41), .so(so40), .so_nxt(si_d40));
flash_delay_cell dly41(.si(si_d40), .nxt_en(adj41), .si_nxt(so42), .so(so41), .so_nxt(si_d41));
flash_delay_cell dly42(.si(si_d41), .nxt_en(adj42), .si_nxt(so43), .so(so42), .so_nxt(si_d42));
flash_delay_cell dly43(.si(si_d42), .nxt_en(adj43), .si_nxt(so44), .so(so43), .so_nxt(si_d43));
flash_delay_cell dly44(.si(si_d43), .nxt_en(adj44), .si_nxt(so45), .so(so44), .so_nxt(si_d44));
flash_delay_cell dly45(.si(si_d44), .nxt_en(adj45), .si_nxt(so46), .so(so45), .so_nxt(si_d45));
flash_delay_cell dly46(.si(si_d45), .nxt_en(adj46), .si_nxt(so47), .so(so46), .so_nxt(si_d46));
flash_delay_cell dly47(.si(si_d46), .nxt_en(adj47), .si_nxt(so48), .so(so47), .so_nxt(si_d47));
flash_delay_cell dly48(.si(si_d47), .nxt_en(adj48), .si_nxt(so49), .so(so48), .so_nxt(si_d48));
flash_delay_cell dly49(.si(si_d48), .nxt_en(adj49), .si_nxt(so50), .so(so49), .so_nxt(si_d49));
flash_delay_cell dly50(.si(si_d49), .nxt_en(adj50), .si_nxt(so51), .so(so50), .so_nxt(si_d50));
flash_delay_cell dly51(.si(si_d50), .nxt_en(adj51), .si_nxt(so52), .so(so51), .so_nxt(si_d51));
flash_delay_cell dly52(.si(si_d51), .nxt_en(adj52), .si_nxt(so53), .so(so52), .so_nxt(si_d52));
flash_delay_cell dly53(.si(si_d52), .nxt_en(adj53), .si_nxt(so54), .so(so53), .so_nxt(si_d53));
flash_delay_cell dly54(.si(si_d53), .nxt_en(adj54), .si_nxt(so55), .so(so54), .so_nxt(si_d54));
flash_delay_cell dly55(.si(si_d54), .nxt_en(adj55), .si_nxt(so56), .so(so55), .so_nxt(si_d55));
flash_delay_cell dly56(.si(si_d55), .nxt_en(adj56), .si_nxt(so57), .so(so56), .so_nxt(si_d56));
flash_delay_cell dly57(.si(si_d56), .nxt_en(adj57), .si_nxt(so58), .so(so57), .so_nxt(si_d57));
flash_delay_cell dly58(.si(si_d57), .nxt_en(adj58), .si_nxt(so59), .so(so58), .so_nxt(si_d58));
flash_delay_cell dly59(.si(si_d58), .nxt_en(adj59), .si_nxt(so60), .so(so59), .so_nxt(si_d59));
flash_delay_cell dly60(.si(si_d59), .nxt_en(adj60), .si_nxt(so61), .so(so60), .so_nxt(si_d60));
flash_delay_cell dly61(.si(si_d60), .nxt_en(adj61), .si_nxt(so62), .so(so61), .so_nxt(si_d61));
flash_delay_cell dly62(.si(si_d61), .nxt_en(adj62), .si_nxt(so63), .so(so62), .so_nxt(si_d62));
flash_delay_cell dly63(.si(si_d62), .nxt_en(adj63), .si_nxt(si_d64), .so(so63), .so_nxt(si_d63));

//flash_delay_cell dly0(.si(si), .nxt_en(adj[0]), .si_nxt(so1), .so(so_t), .so_nxt(si_d0));
//flash_delay_cell dly1(.si(si_d0), .nxt_en(adj[1]), .si_nxt(so2), .so(so1), .so_nxt(si_d1));
//flash_delay_cell dly2(.si(si_d1), .nxt_en(adj[2]), .si_nxt(so3), .so(so2), .so_nxt(si_d2));
//flash_delay_cell dly3(.si(si_d2), .nxt_en(adj[3]), .si_nxt(so4), .so(so3), .so_nxt(si_d3));
//flash_delay_cell dly4(.si(si_d3), .nxt_en(adj[4]), .si_nxt(so5), .so(so4), .so_nxt(si_d4));
//flash_delay_cell dly5(.si(si_d4), .nxt_en(adj[5]), .si_nxt(so6), .so(so5), .so_nxt(si_d5));
//flash_delay_cell dly6(.si(si_d5), .nxt_en(adj[6]), .si_nxt(so7), .so(so6), .so_nxt(si_d6));
//flash_delay_cell dly7(.si(si_d6), .nxt_en(adj[7]), .si_nxt(so8), .so(so7), .so_nxt(si_d7));
//flash_delay_cell dly8(.si(si_d7), .nxt_en(adj[8]), .si_nxt(so9), .so(so8), .so_nxt(si_d8));
//flash_delay_cell dly9(.si(si_d8), .nxt_en(adj[9]), .si_nxt(so10), .so(so9), .so_nxt(si_d9));
//flash_delay_cell dly10(.si(si_d9), .nxt_en(adj[10]), .si_nxt(so11), .so(so10), .so_nxt(si_d10));
//flash_delay_cell dly11(.si(si_d10), .nxt_en(adj[11]), .si_nxt(so12), .so(so11), .so_nxt(si_d11));
//flash_delay_cell dly12(.si(si_d11), .nxt_en(adj[12]), .si_nxt(so13), .so(so12), .so_nxt(si_d12));
//flash_delay_cell dly13(.si(si_d12), .nxt_en(adj[13]), .si_nxt(so14), .so(so13), .so_nxt(si_d13));
//flash_delay_cell dly14(.si(si_d13), .nxt_en(adj[14]), .si_nxt(so15), .so(so14), .so_nxt(si_d14));
//flash_delay_cell dly15(.si(si_d14), .nxt_en(adj[15]), .si_nxt(so16), .so(so15), .so_nxt(si_d15));
//flash_delay_cell dly16(.si(si_d15), .nxt_en(adj[16]), .si_nxt(so17), .so(so16), .so_nxt(si_d16));
//flash_delay_cell dly17(.si(si_d16), .nxt_en(adj[17]), .si_nxt(so18), .so(so17), .so_nxt(si_d17));
//flash_delay_cell dly18(.si(si_d17), .nxt_en(adj[18]), .si_nxt(so19), .so(so18), .so_nxt(si_d18));
//flash_delay_cell dly19(.si(si_d18), .nxt_en(adj[19]), .si_nxt(so20), .so(so19), .so_nxt(si_d19));
//flash_delay_cell dly20(.si(si_d19), .nxt_en(adj[20]), .si_nxt(so21), .so(so20), .so_nxt(si_d20));
//flash_delay_cell dly21(.si(si_d20), .nxt_en(adj[21]), .si_nxt(so22), .so(so21), .so_nxt(si_d21));
//flash_delay_cell dly22(.si(si_d21), .nxt_en(adj[22]), .si_nxt(so23), .so(so22), .so_nxt(si_d22));
//flash_delay_cell dly23(.si(si_d22), .nxt_en(adj[23]), .si_nxt(so24), .so(so23), .so_nxt(si_d23));
//flash_delay_cell dly24(.si(si_d23), .nxt_en(adj[24]), .si_nxt(so25), .so(so24), .so_nxt(si_d24));
//flash_delay_cell dly25(.si(si_d24), .nxt_en(adj[25]), .si_nxt(so26), .so(so25), .so_nxt(si_d25));
//flash_delay_cell dly26(.si(si_d25), .nxt_en(adj[26]), .si_nxt(so27), .so(so26), .so_nxt(si_d26));
//flash_delay_cell dly27(.si(si_d26), .nxt_en(adj[27]), .si_nxt(so28), .so(so27), .so_nxt(si_d27));
//flash_delay_cell dly28(.si(si_d27), .nxt_en(adj[28]), .si_nxt(so29), .so(so28), .so_nxt(si_d28));
//flash_delay_cell dly29(.si(si_d28), .nxt_en(adj[29]), .si_nxt(so30), .so(so29), .so_nxt(si_d29));
//flash_delay_cell dly30(.si(si_d29), .nxt_en(adj[30]), .si_nxt(so31), .so(so30), .so_nxt(si_d30));
//flash_delay_cell dly31(.si(si_d30), .nxt_en(adj[31]), .si_nxt(so32), .so(so31), .so_nxt(si_d31));
//flash_delay_cell dly32(.si(si_d31), .nxt_en(adj[32]), .si_nxt(so33), .so(so32), .so_nxt(si_d32));
//flash_delay_cell dly33(.si(si_d32), .nxt_en(adj[33]), .si_nxt(so34), .so(so33), .so_nxt(si_d33));
//flash_delay_cell dly34(.si(si_d33), .nxt_en(adj[34]), .si_nxt(so35), .so(so34), .so_nxt(si_d34));
//flash_delay_cell dly35(.si(si_d34), .nxt_en(adj[35]), .si_nxt(so36), .so(so35), .so_nxt(si_d35));
//flash_delay_cell dly36(.si(si_d35), .nxt_en(adj[36]), .si_nxt(so37), .so(so36), .so_nxt(si_d36));
//flash_delay_cell dly37(.si(si_d36), .nxt_en(adj[37]), .si_nxt(so38), .so(so37), .so_nxt(si_d37));
//flash_delay_cell dly38(.si(si_d37), .nxt_en(adj[38]), .si_nxt(so39), .so(so38), .so_nxt(si_d38));
//flash_delay_cell dly39(.si(si_d38), .nxt_en(adj[39]), .si_nxt(so40), .so(so39), .so_nxt(si_d39));
//flash_delay_cell dly40(.si(si_d39), .nxt_en(adj[40]), .si_nxt(so41), .so(so40), .so_nxt(si_d40));
//flash_delay_cell dly41(.si(si_d40), .nxt_en(adj[41]), .si_nxt(so42), .so(so41), .so_nxt(si_d41));
//flash_delay_cell dly42(.si(si_d41), .nxt_en(adj[42]), .si_nxt(so43), .so(so42), .so_nxt(si_d42));
//flash_delay_cell dly43(.si(si_d42), .nxt_en(adj[43]), .si_nxt(so44), .so(so43), .so_nxt(si_d43));
//flash_delay_cell dly44(.si(si_d43), .nxt_en(adj[44]), .si_nxt(so45), .so(so44), .so_nxt(si_d44));
//flash_delay_cell dly45(.si(si_d44), .nxt_en(adj[45]), .si_nxt(so46), .so(so45), .so_nxt(si_d45));
//flash_delay_cell dly46(.si(si_d45), .nxt_en(adj[46]), .si_nxt(so47), .so(so46), .so_nxt(si_d46));
//flash_delay_cell dly47(.si(si_d46), .nxt_en(adj[47]), .si_nxt(so48), .so(so47), .so_nxt(si_d47));
//flash_delay_cell dly48(.si(si_d47), .nxt_en(adj[48]), .si_nxt(so49), .so(so48), .so_nxt(si_d48));
//flash_delay_cell dly49(.si(si_d48), .nxt_en(adj[49]), .si_nxt(so50), .so(so49), .so_nxt(si_d49));
//flash_delay_cell dly50(.si(si_d49), .nxt_en(adj[50]), .si_nxt(so51), .so(so50), .so_nxt(si_d50));
//flash_delay_cell dly51(.si(si_d50), .nxt_en(adj[51]), .si_nxt(so52), .so(so51), .so_nxt(si_d51));
//flash_delay_cell dly52(.si(si_d51), .nxt_en(adj[52]), .si_nxt(so53), .so(so52), .so_nxt(si_d52));
//flash_delay_cell dly53(.si(si_d52), .nxt_en(adj[53]), .si_nxt(so54), .so(so53), .so_nxt(si_d53));
//flash_delay_cell dly54(.si(si_d53), .nxt_en(adj[54]), .si_nxt(so55), .so(so54), .so_nxt(si_d54));
//flash_delay_cell dly55(.si(si_d54), .nxt_en(adj[55]), .si_nxt(so56), .so(so55), .so_nxt(si_d55));
//flash_delay_cell dly56(.si(si_d55), .nxt_en(adj[56]), .si_nxt(so57), .so(so56), .so_nxt(si_d56));
//flash_delay_cell dly57(.si(si_d56), .nxt_en(adj[57]), .si_nxt(so58), .so(so57), .so_nxt(si_d57));
//flash_delay_cell dly58(.si(si_d57), .nxt_en(adj[58]), .si_nxt(so59), .so(so58), .so_nxt(si_d58));
//flash_delay_cell dly59(.si(si_d58), .nxt_en(adj[59]), .si_nxt(so60), .so(so59), .so_nxt(si_d59));
//flash_delay_cell dly60(.si(si_d59), .nxt_en(adj[60]), .si_nxt(so61), .so(so60), .so_nxt(si_d60));
//flash_delay_cell dly61(.si(si_d60), .nxt_en(adj[61]), .si_nxt(so62), .so(so61), .so_nxt(si_d61));
//flash_delay_cell dly62(.si(si_d61), .nxt_en(adj[62]), .si_nxt(so63), .so(so62), .so_nxt(si_d62));
//flash_delay_cell dly63(.si(si_d62), .nxt_en(adj[63]), .si_nxt(si_d64), .so(so63), .so_nxt(si_d63));

`ifdef fsh_sim
assign  si_d64 = si_d63;
`else
    `ifdef fpga
        MUXCY dnth_si_fb(.DI(si_d63), .CI(1'b0), .S(1'b0), .O(si_d64));
    `else
        mux2x1 dnth_si_fb(.A(si_d63), .B(1'b0), .S(1'b0), .O(si_d64));
    `endif
`endif

wire si_mux;
    `ifdef fpga
        assign  si_mux = si;
    `else
        mux2x1 dnth_si_mux (.O ( si_mux ) , .A ( si ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_mux)
if(~rst_n)
    adj0 <= 1'b1;
else adj0 <= adj[0];

wire si_d0_mux;
    `ifdef fpga
        assign  si_d0_mux = si_d0;
    `else
mux2x1 dnth_si_d0_mux (.O ( si_d0_mux ) , .A ( si_d0 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d0_mux)
if(~rst_n)
    adj1 <= 1'b1;
else adj1 <= adj[1];

wire si_d1_mux;
    `ifdef fpga
        assign  si_d1_mux = si_d1;
    `else
        mux2x1 dnth_si_d1_mux (.O ( si_d1_mux ) , .A ( si_d1 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d1_mux)
if(~rst_n)
    adj2 <= 1'b1;
else adj2 <= adj[2];

wire si_d2_mux;
    `ifdef fpga
        assign  si_d2_mux = si_d2;
    `else
        mux2x1 dnth_si_d2_mux (.O ( si_d2_mux ) , .A ( si_d2 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d2_mux)
if(~rst_n)
    adj3 <= 1'b1;
else adj3 <= adj[3];

wire si_d3_mux;
    `ifdef fpga
        assign  si_d3_mux = si_d3;
    `else
        mux2x1 dnth_si_d3_mux (.O ( si_d3_mux ) , .A ( si_d3 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d3_mux)
if(~rst_n)
    adj4 <= 1'b1;
else adj4 <= adj[4];

wire si_d4_mux;
    `ifdef fpga
        assign  si_d4_mux = si_d4;
    `else
        mux2x1 dnth_si_d4_mux (.O ( si_d4_mux ) , .A ( si_d4 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d4_mux)
if(~rst_n)
    adj5 <= 1'b1;
else adj5 <= adj[5];

wire si_d5_mux;
    `ifdef fpga
        assign  si_d5_mux = si_d5;
    `else
        mux2x1 dnth_si_d5_mux (.O ( si_d5_mux ) , .A ( si_d5 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d5_mux)
if(~rst_n)
    adj6 <= 1'b1;
else adj6 <= adj[6];

wire si_d6_mux;
    `ifdef fpga
        assign  si_d6_mux = si_d6;
    `else
        mux2x1 dnth_si_d6_mux (.O ( si_d6_mux ) , .A ( si_d6 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d6_mux)
if(~rst_n)
    adj7 <= 1'b1;
else adj7 <= adj[7];

wire si_d7_mux;
    `ifdef fpga
        assign  si_d7_mux = si_d7;
    `else
        mux2x1 dnth_si_d7_mux (.O ( si_d7_mux ) , .A ( si_d7 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d7_mux)
if(~rst_n)
    adj8 <= 1'b1;
else adj8 <= adj[8];

wire si_d8_mux;
    `ifdef fpga
        assign  si_d8_mux = si_d8;
    `else
        mux2x1 dnth_si_d8_mux (.O ( si_d8_mux ) , .A ( si_d8 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d8_mux)
if(~rst_n)
    adj9 <= 1'b1;
else adj9 <= adj[9];

wire si_d9_mux;
    `ifdef fpga
        assign  si_d9_mux = si_d9;
    `else
        mux2x1 dnth_si_d9_mux (.O ( si_d9_mux ) , .A ( si_d9 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d9_mux)
if(~rst_n)
    adj10 <= 1'b1;
else adj10 <= adj[10];

wire si_d10_mux;
    `ifdef fpga
        assign  si_d10_mux = si_d10;
    `else
        mux2x1 dnth_si_d10_mux (.O ( si_d10_mux ) , .A ( si_d10 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d10_mux)
if(~rst_n)
    adj11 <= 1'b1;
else adj11 <= adj[11];

wire si_d11_mux;
    `ifdef fpga
        assign  si_d11_mux = si_d11;
    `else
        mux2x1 dnth_si_d11_mux (.O ( si_d11_mux ) , .A ( si_d11 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d11_mux)
if(~rst_n)
    adj12 <= 1'b1;
else adj12 <= adj[12];

wire si_d12_mux;
    `ifdef fpga
        assign  si_d12_mux = si_d12;
    `else
        mux2x1 dnth_si_d12_mux (.O ( si_d12_mux ) , .A ( si_d12 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d12_mux)
if(~rst_n)
    adj13 <= 1'b1;
else adj13 <= adj[13];

wire si_d13_mux;
    `ifdef fpga
        assign  si_d13_mux = si_d13;
    `else
        mux2x1 dnth_si_d13_mux (.O ( si_d13_mux ) , .A ( si_d13 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d13_mux)
if(~rst_n)
    adj14 <= 1'b1;
else adj14 <= adj[14];

wire si_d14_mux;
    `ifdef fpga
        assign  si_d14_mux = si_d14;
    `else
        mux2x1 dnth_si_d14_mux (.O ( si_d14_mux ) , .A ( si_d14 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d14_mux)
if(~rst_n)
    adj15 <= 1'b1;
else adj15 <= adj[15];

wire si_d15_mux;
    `ifdef fpga
        assign  si_d15_mux = si_d15;
    `else
        mux2x1 dnth_si_d15_mux (.O ( si_d15_mux ) , .A ( si_d15 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d15_mux)
if(~rst_n)
    adj16 <= 1'b1;
else adj16 <= adj[16];

wire si_d16_mux;
    `ifdef fpga
        assign  si_d16_mux = si_d16;
    `else
        mux2x1 dnth_si_d16_mux (.O ( si_d16_mux ) , .A ( si_d16 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d16_mux)
if(~rst_n)
    adj17 <= 1'b1;
else adj17 <= adj[17];

wire si_d17_mux;
    `ifdef fpga
        assign  si_d17_mux = si_d17;
    `else
        mux2x1 dnth_si_d17_mux (.O ( si_d17_mux ) , .A ( si_d17 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d17_mux)
if(~rst_n)
    adj18 <= 1'b1;
else adj18 <= adj[18];

wire si_d18_mux;
    `ifdef fpga
        assign  si_d18_mux = si_d18;
    `else
        mux2x1 dnth_si_d18_mux (.O ( si_d18_mux ) , .A ( si_d18 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d18_mux)
if(~rst_n)
    adj19 <= 1'b1;
else adj19 <= adj[19];

wire si_d19_mux;
    `ifdef fpga
        assign  si_d19_mux = si_d19;
    `else
        mux2x1 dnth_si_d19_mux (.O ( si_d19_mux ) , .A ( si_d19 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d19_mux)
if(~rst_n)
    adj20 <= 1'b1;
else adj20 <= adj[20];

wire si_d20_mux;
    `ifdef fpga
        assign  si_d20_mux = si_d20;
    `else
        mux2x1 dnth_si_d20_mux (.O ( si_d20_mux ) , .A ( si_d20 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d20_mux)
if(~rst_n)
    adj21 <= 1'b1;
else adj21 <= adj[21];

wire si_d21_mux;
    `ifdef fpga
        assign  si_d21_mux = si_d21;
    `else
        mux2x1 dnth_si_d21_mux (.O ( si_d21_mux ) , .A ( si_d21 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d21_mux)
if(~rst_n)
    adj22 <= 1'b1;
else adj22 <= adj[22];

wire si_d22_mux;
    `ifdef fpga
        assign  si_d22_mux = si_d22;
    `else
        mux2x1 dnth_si_d22_mux (.O ( si_d22_mux ) , .A ( si_d22 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d22_mux)
if(~rst_n)
    adj23 <= 1'b1;
else adj23 <= adj[23];

wire si_d23_mux;
    `ifdef fpga
        assign  si_d23_mux = si_d23;
    `else
        mux2x1 dnth_si_d23_mux (.O ( si_d23_mux ) , .A ( si_d23 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d23_mux)
if(~rst_n)
    adj24 <= 1'b1;
else adj24 <= adj[24];

wire si_d24_mux;
    `ifdef fpga
        assign  si_d24_mux = si_d24;
    `else
        mux2x1 dnth_si_d24_mux (.O ( si_d24_mux ) , .A ( si_d24 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d24_mux)
if(~rst_n)
    adj25 <= 1'b1;
else adj25 <= adj[25];

wire si_d25_mux;
    `ifdef fpga
        assign  si_d25_mux = si_d25;
    `else
        mux2x1 dnth_si_d25_mux (.O ( si_d25_mux ) , .A ( si_d25 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d25_mux)
if(~rst_n)
    adj26 <= 1'b1;
else adj26 <= adj[26];

wire si_d26_mux;
    `ifdef fpga
        assign  si_d26_mux = si_d26;
    `else
        mux2x1 dnth_si_d26_mux (.O ( si_d26_mux ) , .A ( si_d26 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d26_mux)
if(~rst_n)
    adj27 <= 1'b1;
else adj27 <= adj[27];

wire si_d27_mux;
    `ifdef fpga
        assign  si_d27_mux = si_d27;
    `else
        mux2x1 dnth_si_d27_mux (.O ( si_d27_mux ) , .A ( si_d27 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d27_mux)
if(~rst_n)
    adj28 <= 1'b1;
else adj28 <= adj[28];

wire si_d28_mux;
    `ifdef fpga
        assign  si_d28_mux = si_d28;
    `else
        mux2x1 dnth_si_d28_mux (.O ( si_d28_mux ) , .A ( si_d28 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d28_mux)
if(~rst_n)
    adj29 <= 1'b1;
else adj29 <= adj[29];

wire si_d29_mux;
    `ifdef fpga
        assign  si_d29_mux = si_d29;
    `else
        mux2x1 dnth_si_d29_mux (.O ( si_d29_mux ) , .A ( si_d29 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d29_mux)
if(~rst_n)
    adj30 <= 1'b1;
else adj30 <= adj[30];

wire si_d30_mux;
    `ifdef fpga
        assign  si_d30_mux = si_d30;
    `else
        mux2x1 dnth_si_d30_mux (.O ( si_d30_mux ) , .A ( si_d30 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d30_mux)
if(~rst_n)
    adj31 <= 1'b1;
else adj31 <= adj[31];

wire si_d31_mux;
    `ifdef fpga
        assign  si_d31_mux = si_d31;
    `else
        mux2x1 dnth_si_d31_mux (.O ( si_d31_mux ) , .A ( si_d31 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d31_mux)
if(~rst_n)
    adj32 <= 1'b1;
else adj32 <= adj[32];

wire si_d32_mux;
    `ifdef fpga
        assign  si_d32_mux = si_d32;
    `else
        mux2x1 dnth_si_d32_mux (.O ( si_d32_mux ) , .A ( si_d32 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d32_mux)
if(~rst_n)
    adj33 <= 1'b1;
else adj33 <= adj[33];

wire si_d33_mux;
    `ifdef fpga
        //MUXCY dnth_si_d33_mux ( .O( si_d33_mux ),  .DI( si_d33 ), .S( test_mode ), .CI(si));
        assign  si_d33_mux = si_d33;
    `else
        mux2x1 dnth_si_d33_mux (.O ( si_d33_mux ) , .A ( si_d33 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d33_mux)
if(~rst_n)
    adj34 <= 1'b1;
else adj34 <= adj[34];

wire si_d34_mux;
    `ifdef fpga
        assign  si_d34_mux = si_d34;
    `else
        mux2x1 dnth_si_d34_mux (.O ( si_d34_mux ) , .A ( si_d34 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d34_mux)
if(~rst_n)
    adj35 <= 1'b1;
else adj35 <= adj[35];

wire si_d35_mux;
    `ifdef fpga
        assign  si_d35_mux = si_d35;
    `else
        mux2x1 dnth_si_d35_mux (.O ( si_d35_mux ) , .A ( si_d35 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d35_mux)
if(~rst_n)
    adj36 <= 1'b1;
else adj36 <= adj[36];

wire si_d36_mux;
    `ifdef fpga
        assign  si_d36_mux = si_d36;
    `else
        mux2x1 dnth_si_d36_mux (.O ( si_d36_mux ) , .A ( si_d36 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d36_mux)
if(~rst_n)
    adj37 <= 1'b1;
else adj37 <= adj[37];

wire si_d37_mux;
    `ifdef fpga
        assign  si_d37_mux = si_d37;
    `else
        mux2x1 dnth_si_d37_mux (.O ( si_d37_mux ) , .A ( si_d37 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d37_mux)
if(~rst_n)
    adj38 <= 1'b1;
else adj38 <= adj[38];

wire si_d38_mux;
    `ifdef fpga
        assign  si_d38_mux = si_d38;
    `else
        mux2x1 dnth_si_d38_mux (.O ( si_d38_mux ) , .A ( si_d38 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d38_mux)
if(~rst_n)
    adj39 <= 1'b1;
else adj39 <= adj[39];

wire si_d39_mux;
    `ifdef fpga
        assign  si_d39_mux = si_d39;
    `else
        mux2x1 dnth_si_d39_mux (.O ( si_d39_mux ) , .A ( si_d39 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d39_mux)
if(~rst_n)
    adj40 <= 1'b1;
else adj40 <= adj[40];

wire si_d40_mux;
    `ifdef fpga
        assign  si_d40_mux = si_d40;
    `else
        mux2x1 dnth_si_d40_mux (.O ( si_d40_mux ) , .A ( si_d40 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d40_mux)
if(~rst_n)
    adj41 <= 1'b1;
else adj41 <= adj[41];

wire si_d41_mux;
    `ifdef fpga
        assign  si_d41_mux = si_d41;
    `else
        mux2x1 dnth_si_d41_mux (.O ( si_d41_mux ) , .A ( si_d41 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d41_mux)
if(~rst_n)
    adj42 <= 1'b1;
else adj42 <= adj[42];

wire si_d42_mux;
    `ifdef fpga
        assign  si_d42_mux = si_d42;
    `else
        mux2x1 dnth_si_d42_mux (.O ( si_d42_mux ) , .A ( si_d42 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d42_mux)
if(~rst_n)
    adj43 <= 1'b1;
else adj43 <= adj[43];

wire si_d43_mux;
    `ifdef fpga
        assign  si_d43_mux = si_d43;
    `else
        mux2x1 dnth_si_d43_mux (.O ( si_d43_mux ) , .A ( si_d43 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d43_mux)
if(~rst_n)
    adj44 <= 1'b1;
else adj44 <= adj[44];

wire si_d44_mux;
    `ifdef fpga
        assign  si_d44_mux = si_d44;
    `else
        mux2x1 dnth_si_d44_mux (.O ( si_d44_mux ) , .A ( si_d44 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d44_mux)
if(~rst_n)
    adj45 <= 1'b1;
else adj45 <= adj[45];

wire si_d45_mux;
    `ifdef fpga
        assign  si_d45_mux = si_d45;
    `else
        mux2x1 dnth_si_d45_mux (.O ( si_d45_mux ) , .A ( si_d45 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d45_mux)
if(~rst_n)
    adj46 <= 1'b1;
else adj46 <= adj[46];

wire si_d46_mux;
    `ifdef fpga
        assign  si_d46_mux = si_d46;
    `else
        mux2x1 dnth_si_d46_mux (.O ( si_d46_mux ) , .A ( si_d46 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d46_mux)
if(~rst_n)
    adj47 <= 1'b1;
else adj47 <= adj[47];

wire si_d47_mux;
    `ifdef fpga
        assign  si_d47_mux = si_d47;
    `else
        mux2x1 dnth_si_d47_mux (.O ( si_d47_mux ) , .A ( si_d47 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d47_mux)
if(~rst_n)
    adj48 <= 1'b1;
else adj48 <= adj[48];

wire si_d48_mux;
    `ifdef fpga
        assign  si_d48_mux = si_d48;
    `else
        mux2x1 dnth_si_d48_mux (.O ( si_d48_mux ) , .A ( si_d48 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d48_mux)
if(~rst_n)
    adj49 <= 1'b1;
else adj49 <= adj[49];

wire si_d49_mux;
    `ifdef fpga
        assign  si_d49_mux = si_d49;
    `else
        mux2x1 dnth_si_d49_mux (.O ( si_d49_mux ) , .A ( si_d49 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d49_mux)
if(~rst_n)
    adj50 <= 1'b1;
else adj50 <= adj[50];

wire si_d50_mux;
    `ifdef fpga
        assign  si_d50_mux = si_d50;
    `else
        mux2x1 dnth_si_d50_mux (.O ( si_d50_mux ) , .A ( si_d50 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d50_mux)
if(~rst_n)
    adj51 <= 1'b1;
else adj51 <= adj[51];

wire si_d51_mux;
    `ifdef fpga
        assign  si_d51_mux = si_d51;
    `else
        mux2x1 dnth_si_d51_mux (.O ( si_d51_mux ) , .A ( si_d51 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d51_mux)
if(~rst_n)
    adj52 <= 1'b1;
else adj52 <= adj[52];

wire si_d52_mux;
    `ifdef fpga
        assign  si_d52_mux = si_d52;
    `else
        mux2x1 dnth_si_d52_mux (.O ( si_d52_mux ) , .A ( si_d52 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d52_mux)
if(~rst_n)
    adj53 <= 1'b1;
else adj53 <= adj[53];

wire si_d53_mux;
    `ifdef fpga
        assign  si_d53_mux = si_d53;
    `else
        mux2x1 dnth_si_d53_mux (.O ( si_d53_mux ) , .A ( si_d53 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d53_mux)
if(~rst_n)
    adj54 <= 1'b1;
else adj54 <= adj[54];

wire si_d54_mux;
    `ifdef fpga
        assign  si_d54_mux = si_d54;
    `else
        mux2x1 dnth_si_d54_mux (.O ( si_d54_mux ) , .A ( si_d54 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d54_mux)
if(~rst_n)
    adj55 <= 1'b1;
else adj55 <= adj[55];

wire si_d55_mux;
    `ifdef fpga
        assign  si_d55_mux = si_d55;
    `else
        mux2x1 dnth_si_d55_mux (.O ( si_d55_mux ) , .A ( si_d55 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d55_mux)
if(~rst_n)
    adj56 <= 1'b1;
else adj56 <= adj[56];

wire si_d56_mux;
    `ifdef fpga
        assign  si_d56_mux = si_d56;
    `else
        mux2x1 dnth_si_d56_mux (.O ( si_d56_mux ) , .A ( si_d56 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d56_mux)
if(~rst_n)
    adj57 <= 1'b1;
else adj57 <= adj[57];

wire si_d57_mux;
    `ifdef fpga
        assign  si_d57_mux = si_d57;
    `else
        mux2x1 dnth_si_d57_mux (.O ( si_d57_mux ) , .A ( si_d57 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d57_mux)
if(~rst_n)
    adj58 <= 1'b1;
else adj58 <= adj[58];

wire si_d58_mux;
    `ifdef fpga
        assign  si_d58_mux = si_d58;
    `else
        mux2x1 dnth_si_d58_mux (.O ( si_d58_mux ) , .A ( si_d58 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d58_mux)
if(~rst_n)
    adj59 <= 1'b1;
else adj59 <= adj[59];

wire si_d59_mux;
    `ifdef fpga
        assign  si_d59_mux = si_d59;
    `else
        mux2x1 dnth_si_d59_mux (.O ( si_d59_mux ) , .A ( si_d59 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d59_mux)
if(~rst_n)
    adj60 <= 1'b1;
else adj60 <= adj[60];

wire si_d60_mux;
    `ifdef fpga
        assign  si_d60_mux = si_d60;
    `else
        mux2x1 dnth_si_d60_mux (.O ( si_d60_mux ) , .A ( si_d60 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d60_mux)
if(~rst_n)
    adj61 <= 1'b1;
else adj61 <= adj[61];

wire si_d61_mux;
    `ifdef fpga
        assign  si_d61_mux = si_d61;
    `else
        mux2x1 dnth_si_d61_mux (.O ( si_d61_mux ) , .A ( si_d61 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d61_mux)
if(~rst_n)
    adj62 <= 1'b1;
else adj62 <= adj[62];

wire si_d62_mux;
    `ifdef fpga
        assign  si_d62_mux = si_d62;
    `else
        mux2x1 dnth_si_d62_mux (.O ( si_d62_mux ) , .A ( si_d62 ) , .S ( test_mode ) , .B ( si ) );
    `endif
always @(negedge rst_n or negedge si_d62_mux)
if(~rst_n)
    adj63 <= 1'b1;
else adj63 <= adj[63];



endmodule
