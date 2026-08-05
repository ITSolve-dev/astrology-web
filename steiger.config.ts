import fsd from '@feature-sliced/steiger-plugin'
import { defineConfig } from 'steiger'

export default defineConfig([
  ...fsd.configs.recommended,
  {
    ignores: ['**/node_modules/**', '**/dist/**', '**/.worktrees/**'],
  },
  {
    // Project intentionally uses purpose-named segments (shared/validation,
    // app/providers) instead of strict FSD canonical segment names — see
    // the frontend design doc §3.5 for the agreed folder structure.
    files: ['./src/shared/**', './src/app/**'],
    rules: {
      'fsd/segments-by-purpose': 'off',
    },
  },
])
