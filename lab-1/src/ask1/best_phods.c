/***********************************************************************************************************************
 * Copyright [2015-2021] Renesas Electronics Corporation and/or its licensors.
 *All Rights Reserved.
 *
 * This file is part of Renesas SynergyTM Software Package (SSP)
 *
 * The contents of this file (the "contents") are proprietary and confidential
 *to Renesas Electronics Corporation and/or its licensors ("Renesas") and
 *subject to statutory and contractual protections.
 *
 * This file is subject to a Renesas SSP license agreement. Unless otherwise
 *agreed in an SSP license agreement with Renesas: 1) you may not use, copy,
 *modify, distribute, display, or perform the contents; 2) you may not use any
 *name or mark of Renesas for advertising or publicity purposes or in connection
 *with your use of the contents; 3) RENESAS MAKES NO WARRANTY OR REPRESENTATIONS
 *ABOUT THE SUITABILITY OF THE CONTENTS FOR ANY PURPOSE; THE CONTENTS ARE
 *PROVIDED "AS IS" WITHOUT ANY EXPRESS OR IMPLIED WARRANTY, INCLUDING THE
 *IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
 *NON-INFRINGEMENT; AND 4) RENESAS SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT,
 *SPECIAL, OR CONSEQUENTIAL DAMAGES, INCLUDING DAMAGES RESULTING FROM LOSS OF
 *USE, DATA, OR PROJECTS, WHETHER IN AN ACTION OF CONTRACT OR TORT, ARISING OUT
 *OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THE CONTENTS. Third-party
 *contents included in this file may be subject to different terms.
 **********************************************************************************************************************/
/***********************************************************************************************************************
 * File Name    : hal_entry.c
 * Description  : This is a very simple example application that blinks all LEDs
 *on a board.
 ***********************************************************************************************************************/

#include "hal_data.h"
#include "images.h"
#include "stdio.h"
#include "stdlib.h"
#include "string.h"

#define N 10 /*Frame dimension for QCIF format*/
#define M 10 /*Frame dimension for QCIF format*/
#define CPU_FREQ 240000000
#define B 5 /*Block size*/

#define p 7 /*Search space. Restricted in a [-p,p] region around the                   \
//      original location of the block.*/

//Global Variable Declarations
const int NdivB=N/B, MdivB=M/B, Nminus1=N-1, Mminus1=M-1, mul=255*B*B;

void phods_motion_estimation(const int current[N][M], const int previous[N][M],
                             int vectors_x[NdivB][MdivB],
                             int vectors_y[NdivB][MdivB]) {
  int x, y, i, j, k, l, p1, p2, q2, distx, disty, S, min1, min2, bestx, besty;
  int vector_Bxk, vector_Byl, vector_Bxi, vector_Byi, vector_Bxik, vector_Byil;
  distx = 0;
  disty = 0;

  /*For all blocks in the current frame*/
  for (x = 0; x < NdivB; x++) {
    for (y = 0; y < MdivB; y++) {
        vectors_x[x][y] = 0;
        vectors_y[x][y] = 0;
        S = 4;

      while (S > 0) {
        int vector_Bx = vectors_x[x][y] + B*x;
        int vector_By = vectors_y[x][y] + B*y;

        min1 = mul;
        min2 = mul;

        /*For all candidate blocks in X dimension*/
        for (i = -S; i < S + 1; i += S) {
          distx = 0;
          disty = 0;

          vector_Bxi = vector_Bx + i;
          vector_Byi = vector_By + i;
          /*For all pixels in the block*/
          for (k = 0; k < B; k++) {
            vector_Bxik = vector_Bxi + k;
            vector_Bxk = vector_Bx + k;
            for (l = 0; l < B; l++) {
              vector_Byil = vector_Byi + l;
              vector_Byl = vector_By + l;
              p1 = current[B*x + k][B*y + l];

              if (vector_Bxik < 0 || vector_Bxik > (Nminus1) || vector_Byl < 0 ||
                  vector_Byl > (Mminus1)) {
                p2 = 0;
              } else {
                p2 = previous[vector_Bxik][vector_Byl];
              }
              distx += abs(p1 - p2);

              if (vector_Bxk < 0 || vector_Bxk > (Nminus1) || vector_Byil < 0 ||
                  vector_Byil > (Mminus1)) {
                q2 = 0;
              } else {
                q2 = previous[vector_Bxk][vector_Byil];
              }
              disty += abs(p1 - q2);
            }
          }
          if (distx < min1) {
            min1 = distx;
            bestx = i;
          }

          if (disty < min2) {
            min2 = disty;
            besty = i;

        }
        }

        S = S / 2;
        vectors_x[x][y] += bestx;
        vectors_y[x][y] += besty;
      }
    }
  }
}

void convert1DTo2D(const int array[], int array_correct[N][M]) {
   int index_1d = 0;
   for (int i = 0; i < N; ++i) {
       for (int j = 0; j < M; ++j) {
           array_correct[i][j] = array[index_1d++];
       }
   }
}
/*******************************************************************************************************************/ /**
* @brief  Blinky example application
** Blinks all leds at a rate of 1 second using the software delay function provided by the BSP.
* Only references two other modules including the BSP, IOPORT.
**********************************************************************************************************************/
void hal_entry(void) {
  // Code to initialize the DWT->CYCCNT register
  CoreDebug->DEMCR |= 0x01000000;
  ITM->LAR = 0xC5ACCE55;
  DWT->CYCCNT = 0;
  DWT->CTRL |= 1;
  /* Initialize your variables here */
  uint32_t start_cyc, end_cyc, run_cyc, total_cyc=0, min=UINT32_MAX, max=0;
  int previous1[N][M], current1[N][M],motion_vectors_x[N/B][M/B], motion_vectors_y[N/B][M/B], i, j;
  convert1DTo2D(previous2, previous1);
  convert1DTo2D(current2, current1);
  for (int run=0; run <10; run ++) {
    /* Add timer code here */
    start_cyc = DWT->CYCCNT;
    phods_motion_estimation(current1, previous1, motion_vectors_x,
                            motion_vectors_y);
    end_cyc = DWT->CYCCNT;
    run_cyc = end_cyc - start_cyc;
    total_cyc += run_cyc;
    if (run_cyc > max){
        max=run_cyc;
    }
    if (run_cyc<min){
        min=run_cyc;
    }
  }
  float average_time = (float)total_cyc/10/CPU_FREQ;
  float min_time = (float)min / CPU_FREQ;
  float max_time = (float)max / CPU_FREQ;
}