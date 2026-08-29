// cla64_hier.v
// BONUS -- open-ended. No detailed scaffold is provided; this is meant to
// be a genuine design exercise. Not required for lab submission.
//
// You will likely need to modify cla4.v (or add signals alongside it) so
// that block-generate/block-propagate summaries of its own Gi, Pi signals
// are exposed as outputs, since the second-level lookahead unit below
// needs them. As with every module in this lab from Task 2 onward, every
// gate/assign you add should carry an explicit delay.
//
// Starting point (from Tutorial 3, Q4(d)):
//   - Reuse 16 four-bit CLA blocks (your cla4.v) -- their internal logic
//     doesn't change.
//   - For each block k, define:
//       Gblk_k = "this block produces a carry regardless of its incoming
//                 carry" -- a Boolean function of that block's own 4
//                 bit-level Gi, Pi signals.
//       Pblk_k = "an incoming carry sails straight through this whole
//                 block" -- likewise a function of its own Gi, Pi.
//   - Build a second-level lookahead unit -- structurally identical to
//     cla4.v, just one level up -- that computes each block's carry-in
//     directly from Gblk_0..Gblk_15, Pblk_0..Pblk_15, and cin, instead of
//     rippling block to block.
//
// To test this, wire it into dut.v as a fourth option (copy the pattern
// used for the other three) and run it through the same tb.v. Compare
// your final delay to cla64_blocked.v from Task 4.

// cla64_hier.v
// Two-level hierarchical CLA: 16 four-bit CLA blocks (cla4.v, modified to
// expose Gblk/Pblk) + one second-level lookahead unit, structurally
// identical to cla4.v's own carry logic, just one level up (16-wide
// instead of 4-wide) so block carry-ins are computed directly instead of
// rippling block to block.

// cla64_hier.v
// Two-level hierarchical CLA: 16 four-bit CLA blocks (cla4.v, modified to
// expose Gblk/Pblk) + one second-level lookahead unit, structurally
// identical to cla4.v's own carry logic, just one level up (16-wide
// instead of 4-wide) so block carry-ins are computed directly instead of
// rippling block to block.

module cla64_hier(
  input  [63:0] a,
  input  [63:0] b,
  input         cin,
  output [63:0] sum,
  output        cout
);
  // NOTE: Gblk/Pblk are NOT ports of this module -- they're internal
  // wires used to connect the 16 cla4 blocks to the second-level
  // lookahead logic below. Do not add them to the port list above.

  wire [15:0] Gblk, Pblk;   // block-level generate/propagate, one pair per 4-bit block
  wire [16:1] Cblk;         // Cblk[k] = carry INTO block k (1-indexed like c[] in cla4/cla64_flat)
                             // Cblk[16] is the final carry out of the whole adder
  wire [15:0] block_cout_unused; // per-block cout from cla4 instances (redundant with Cblk, unused)

  // ---------------------------------------------------------------------
  // Second-level lookahead: computes every block's carry-in directly from
  // Gblk[0..15], Pblk[0..15], and cin. Same pattern as c[1]..c[64] in
  // cla64_flat.v, just with 16 block-terms instead of 64 bit-terms.
  // ---------------------------------------------------------------------
  assign #(2) Cblk[1] = Gblk[0] | Pblk[0]*cin;
  assign #(2) Cblk[2] = Gblk[1] | Pblk[1]*Gblk[0] | Pblk[1]*Pblk[0]*cin;
  assign #(2) Cblk[3] = Gblk[2] | Pblk[2]*Gblk[1] | Pblk[2]*Pblk[1]*Gblk[0] | Pblk[2]*Pblk[1]*Pblk[0]*cin;
  assign #(2) Cblk[4] = Gblk[3] | Pblk[3]*Gblk[2] | Pblk[3]*Pblk[2]*Gblk[1] | Pblk[3]*Pblk[2]*Pblk[1]*Gblk[0] | Pblk[3]*Pblk[2]*Pblk[1]*Pblk[0]*cin;
  assign #(2) Cblk[5] = Gblk[4] | Pblk[4]*Gblk[3] | Pblk[4]*Pblk[3]*Gblk[2] | Pblk[4]*Pblk[3]*Pblk[2]*Gblk[1] | Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Gblk[0] | Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Pblk[0]*cin;
  assign #(2) Cblk[6] = Gblk[5] | Pblk[5]*Gblk[4] | Pblk[5]*Pblk[4]*Gblk[3] | Pblk[5]*Pblk[4]*Pblk[3]*Gblk[2] | Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Gblk[1] | Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Gblk[0] | Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Pblk[0]*cin;
  assign #(2) Cblk[7] = Gblk[6] | Pblk[6]*Gblk[5] | Pblk[6]*Pblk[5]*Gblk[4] | Pblk[6]*Pblk[5]*Pblk[4]*Gblk[3] | Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Gblk[2] | Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Gblk[1] | Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Gblk[0] | Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Pblk[0]*cin;
  assign #(2) Cblk[8] = Gblk[7] | Pblk[7]*Gblk[6] | Pblk[7]*Pblk[6]*Gblk[5] | Pblk[7]*Pblk[6]*Pblk[5]*Gblk[4] | Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Gblk[3] | Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Gblk[2] | Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Gblk[1] | Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Gblk[0] | Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Pblk[0]*cin;
  assign #(2) Cblk[9] = Gblk[8] | Pblk[8]*Gblk[7] | Pblk[8]*Pblk[7]*Gblk[6] | Pblk[8]*Pblk[7]*Pblk[6]*Gblk[5] | Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Gblk[4] | Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Gblk[3] | Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Gblk[2] | Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Gblk[1] | Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Gblk[0] | Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Pblk[0]*cin;
  assign #(2) Cblk[10] = Gblk[9] | Pblk[9]*Gblk[8] | Pblk[9]*Pblk[8]*Gblk[7] | Pblk[9]*Pblk[8]*Pblk[7]*Gblk[6] | Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Gblk[5] | Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Gblk[4] | Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Gblk[3] | Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Gblk[2] | Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Gblk[1] | Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Gblk[0] | Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Pblk[0]*cin;
  assign #(2) Cblk[11] = Gblk[10] | Pblk[10]*Gblk[9] | Pblk[10]*Pblk[9]*Gblk[8] | Pblk[10]*Pblk[9]*Pblk[8]*Gblk[7] | Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Gblk[6] | Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Gblk[5] | Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Gblk[4] | Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Gblk[3] | Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Gblk[2] | Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Gblk[1] | Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Gblk[0] | Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Pblk[0]*cin;
  assign #(2) Cblk[12] = Gblk[11] | Pblk[11]*Gblk[10] | Pblk[11]*Pblk[10]*Gblk[9] | Pblk[11]*Pblk[10]*Pblk[9]*Gblk[8] | Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Gblk[7] | Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Gblk[6] | Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Gblk[5] | Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Gblk[4] | Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Gblk[3] | Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Gblk[2] | Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Gblk[1] | Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Gblk[0] | Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Pblk[0]*cin;
  assign #(2) Cblk[13] = Gblk[12] | Pblk[12]*Gblk[11] | Pblk[12]*Pblk[11]*Gblk[10] | Pblk[12]*Pblk[11]*Pblk[10]*Gblk[9] | Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Gblk[8] | Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Gblk[7] | Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Gblk[6] | Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Gblk[5] | Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Gblk[4] | Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Gblk[3] | Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Gblk[2] | Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Gblk[1] | Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Gblk[0] | Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Pblk[0]*cin;
  assign #(2) Cblk[14] = Gblk[13] | Pblk[13]*Gblk[12] | Pblk[13]*Pblk[12]*Gblk[11] | Pblk[13]*Pblk[12]*Pblk[11]*Gblk[10] | Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Gblk[9] | Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Gblk[8] | Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Gblk[7] | Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Gblk[6] | Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Gblk[5] | Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Gblk[4] | Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Gblk[3] | Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Gblk[2] | Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Gblk[1] | Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Gblk[0] | Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Pblk[0]*cin;
  assign #(2) Cblk[15] = Gblk[14] | Pblk[14]*Gblk[13] | Pblk[14]*Pblk[13]*Gblk[12] | Pblk[14]*Pblk[13]*Pblk[12]*Gblk[11] | Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Gblk[10] | Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Gblk[9] | Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Gblk[8] | Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Gblk[7] | Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Gblk[6] | Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Gblk[5] | Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Gblk[4] | Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Gblk[3] | Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Gblk[2] | Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Gblk[1] | Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Gblk[0] | Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Pblk[0]*cin;
  assign #(2) Cblk[16] = Gblk[15] | Pblk[15]*Gblk[14] | Pblk[15]*Pblk[14]*Gblk[13] | Pblk[15]*Pblk[14]*Pblk[13]*Gblk[12] | Pblk[15]*Pblk[14]*Pblk[13]*Pblk[12]*Gblk[11] | Pblk[15]*Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Gblk[10] | Pblk[15]*Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Gblk[9] | Pblk[15]*Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Gblk[8] | Pblk[15]*Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Gblk[7] | Pblk[15]*Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Gblk[6] | Pblk[15]*Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Gblk[5] | Pblk[15]*Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Gblk[4] | Pblk[15]*Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Gblk[3] | Pblk[15]*Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Gblk[2] | Pblk[15]*Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Gblk[1] | Pblk[15]*Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Gblk[0] | Pblk[15]*Pblk[14]*Pblk[13]*Pblk[12]*Pblk[11]*Pblk[10]*Pblk[9]*Pblk[8]*Pblk[7]*Pblk[6]*Pblk[5]*Pblk[4]*Pblk[3]*Pblk[2]*Pblk[1]*Pblk[0]*cin;

  assign cout = Cblk[16];

  // ---------------------------------------------------------------------
  // 16 four-bit CLA blocks. Each block's cin comes directly from the
  // second-level lookahead above (Cblk[k]), NOT from the previous block's
  // cout -- that's what removes the block-to-block ripple.
  // Block k covers bits [4k+3 : 4k], for k = 0..15.
  // ---------------------------------------------------------------------
  genvar k;
  generate
    for (k = 0; k < 16; k = k + 1) begin : gen_block
      wire block_cin = (k == 0) ? cin : Cblk[k];
      cla4 BLOCK (
        .a    (a[4*k+3 : 4*k]),
        .b    (b[4*k+3 : 4*k]),
        .cin  (block_cin),
        .sum  (sum[4*k+3 : 4*k]),
        .cout (block_cout_unused[k]),   // redundant with Cblk[k+1]; unused
        .Gblk (Gblk[k]),
        .Pblk (Pblk[k])
      );
    end
  endgenerate

endmodule