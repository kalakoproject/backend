import cron from 'node-cron';
import { query } from '../db.js';

/**
 * Scheduled job untuk mengubah status client menjadi suspended jika trial sudah berakhir
 * Berjalan setiap hari pada jam 00:01 (1 menit setelah tengah malam)
 */
export function startTrialExpireJob() {
  // Jalankan setiap hari pada jam 00:01
  const task = cron.schedule('1 0 * * *', async () => {
    console.log('[Trial Expire Job] Checking for expired trials...');
    
    try {
      const result = await query(
        `UPDATE clients
         SET status = 'suspended', suspended_at = NOW(), suspension_reason = 'Trial period expired'
         WHERE status = 'trial' AND trial_ends_at <= NOW()
         RETURNING id, name, trial_ends_at`
      );

      if (result.rowCount > 0) {
        console.log(`[Trial Expire Job] Updated ${result.rowCount} clients to suspended:`, result.rows);
      } else {
        console.log('[Trial Expire Job] No expired trials found');
      }
    } catch (err) {
      console.error('[Trial Expire Job] Error:', err.message);
    }
  });

  console.log('[Trial Expire Job] Started - will run daily at 00:01');
  return task;
}
