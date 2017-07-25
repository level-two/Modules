// -----------------------------------------------------------------------------
//    Copyright © 2017 Yauheni Lychkouski.
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.
// -----------------------------------------------------------------------------
// File: crossdomain_signal.v
// Description: Block for crossing signal from one clk domain to another
// -----------------------------------------------------------------------------


module crossdomain_signal (
    input         reset,
    input         clk_b,
    input         sig_domain_a,
    output        sig_domain_b
);

    reg [1:0] sig_domain_b_reg;
    always @(posedge reset or posedge clk_b) begin
        if (reset) begin
            sig_domain_b_reg <= 2'b0;
        end
        else begin
            sig_domain_b_reg[1:0] <= { sig_domain_b_reg[0], sig_domain_a };
        end
    end

    assign sig_domain_b = sig_domain_b_reg[1];

endmodule
