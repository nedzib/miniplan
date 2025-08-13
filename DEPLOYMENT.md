# Deployment Instructions

## Rails 8 Solid Tables Migration

This application uses Rails 8 with Solid Cache, Solid Queue, and Solid Cable. These require specific database tables to be created in production.

### For Production Deployment:

1. **Run all migrations including the new solid tables:**
   ```bash
   rails db:migrate
   ```

2. **The following migrations were added to support Rails 8 solid features:**
   - `20250813205454_create_solid_cache_entries.rb` - Creates solid_cache_entries table
   - `20250813205543_create_solid_queue_tables.rb` - Creates all solid_queue_* tables
   - `20250813205659_create_solid_cable_messages.rb` - Creates solid_cable_messages table

3. **If you get the error about missing solid_cache_entries table:**
   This means the migrations haven't been run in production yet. Simply run:
   ```bash
   rails db:migrate
   ```

### Tables Created:

**Solid Cache:**
- `solid_cache_entries`

**Solid Queue:**
- `solid_queue_blocked_executions`
- `solid_queue_claimed_executions`
- `solid_queue_failed_executions`
- `solid_queue_jobs`
- `solid_queue_pauses`
- `solid_queue_processes`
- `solid_queue_ready_executions`
- `solid_queue_recurring_executions`
- `solid_queue_recurring_tasks`
- `solid_queue_scheduled_executions`
- `solid_queue_semaphores`

**Solid Cable:**
- `solid_cable_messages`

### Configuration Files:

The following configuration files were automatically created/updated:
- `config/cache.yml`
- `config/queue.yml`
- `config/recurring.yml`
- `config/cable.yml`

These are already configured for production use with solid adapters.
