/*
 * Copyright (c) 2020, NVIDIA CORPORATION. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

#include <gst/gst.h>
#include <glib.h>
#include <iostream>
#include <vector>
#include <unordered_map>
#include <sstream>
#include "gstnvdsmeta.h"
#include "nvds_analytics_meta.h"
#include "analytics.h"

/* custom_parse_nvdsanalytics_meta_data
 * and extract nvanalytics metadata */
extern "C" void
analytics_custom_parse_nvdsanalytics_meta_data (NvDsMetaList *l_user, AnalyticsUserMeta *data)
{
    // --- STATEFUL LOGIC START ---
    // This logic maintains a running count of occupancy across frames.

    // Static variables are initialized only once and retain their values across function calls.
    static int cumulative_occupancy = 0;
    static uint32_t prev_entry_count = 0;
    static uint32_t prev_exit_count = 0;

    // Standard metadata extraction from the user meta list
    NvDsUserMeta *user_meta = (NvDsUserMeta *) l_user->data;
    NvDsAnalyticsFrameMeta *meta =
        (NvDsAnalyticsFrameMeta *) user_meta->user_meta_data;

    // Get the latest cumulative line crossing counts from the NvAnalytics plugin
    uint32_t current_entry_count = meta->objLCCumCnt["Entry"];
    uint32_t current_exit_count = meta->objLCCumCnt["Exit"];

    // Calculate the change (delta) in counts since the last frame was processed
    uint32_t entries_this_frame = current_entry_count - prev_entry_count;
    uint32_t exits_this_frame = current_exit_count - prev_exit_count;

    // Update our persistent occupancy count based on the change in this frame
    cumulative_occupancy += entries_this_frame;
    cumulative_occupancy -= exits_this_frame;

    // Safety check: Occupancy cannot be physically negative.
    // This handles cases of detection errors (e.g., a missed entry or a false exit).
    if (cumulative_occupancy < 0) {
        cumulative_occupancy = 0;
    }

    // Populate the custom data structure with the latest values
    data->lcc_cnt_entry = current_entry_count;
    data->lcc_cnt_exit = current_exit_count;
    data->lccum_cnt = cumulative_occupancy; // Use our stateful, correct occupancy

    // CRITICAL STEP: Update the 'previous' counts to be the 'current' counts,
    // so they are ready for the next frame's calculation.
    prev_entry_count = current_entry_count;
    prev_exit_count = current_exit_count;

    // --- STATEFUL LOGIC END ---
}
