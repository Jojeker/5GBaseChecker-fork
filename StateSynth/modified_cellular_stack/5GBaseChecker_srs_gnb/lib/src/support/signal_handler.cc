/**
 * Copyright 2013-2022 Software Radio Systems Limited
 *
 * This file is part of srsRAN.
 *
 * srsRAN is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of
 * the License, or (at your option) any later version.
 *
 * srsRAN is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * A copy of the GNU Affero General Public License can be found in
 * the LICENSE file in the top-level directory of this distribution
 * and at http://www.gnu.org/licenses/.
 *
 */

#include "srsran/support/signal_handler.h"
#include "srsran/support/emergency_handlers.h"
#include <atomic>
#include <csignal>
#include <cstdio>
#include <unistd.h>
#include <fcntl.h>
#include <time.h>


#ifdef ENABLE_DUMP
extern "C" void __afl_manual_init(void);

__attribute__((constructor))
static void init_afl() {
  __afl_manual_init();   // sets up the bitmap even without afl-fuzz/showmap
}


// Get AFL stuff and dump it manually
extern "C" {
  __attribute__((weak)) unsigned char *__afl_area_ptr;
  __attribute__((weak)) unsigned int  __afl_map_size;
}

#endif

#ifndef SRSRAN_TERM_TIMEOUT_S
#define SRSRAN_TERM_TIMEOUT_S (5)
#endif

/// Handler called after the user interrupts the program.
static std::atomic<srsran_signal_hanlder> user_handler;

static void srsran_signal_handler(int signal)
{
  switch (signal) {
    case SIGALRM:
      fprintf(stderr, "Couldn't stop after %ds. Forcing exit.\n", SRSRAN_TERM_TIMEOUT_S);
      execute_emergency_cleanup_handlers();
      raise(SIGKILL);
    default:
      // all other registered signals try to stop the app gracefully
      // Call the user handler if present and remove it so that further signals are treated by the default handler.
#ifdef ENABLE_DUMP
#pragma  message("ASAN enabled, dumping coverage")

        pid_t p = getpid();
	time_t ts = time(NULL);
        char buf[256];
	snprintf(buf, sizeof(buf), "/data/coverage/afl_cov_%ld_%d.bin", (long)ts, (int)p);
        int fd = open(buf, O_WRONLY|O_CREAT|O_TRUNC, 0600);
	if (fd >= 0) { write(fd, __afl_area_ptr, __afl_map_size); close(fd); }

	raise(SIGKILL);
#endif
      if (auto handler = user_handler.exchange(nullptr)) {
        handler();
      } else {
        return;
      }
      fprintf(stdout, "Stopping ..\n");
      alarm(SRSRAN_TERM_TIMEOUT_S);
      break;
  }
}

void srsran_register_signal_handler(srsran_signal_hanlder handler)
{
  user_handler.store(handler);

  signal(SIGINT, srsran_signal_handler);
  signal(SIGTERM, srsran_signal_handler);
  signal(SIGHUP, srsran_signal_handler);
  signal(SIGALRM, srsran_signal_handler);
}
