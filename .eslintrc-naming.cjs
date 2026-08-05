const checkFile = require('eslint-plugin-check-file')
const tseslint = require('typescript-eslint')

module.exports = [
  {
    files: ['src/**/*.{ts,tsx}'],
    languageOptions: {
      parser: tseslint.parser,
      parserOptions: {
        ecmaFeatures: { jsx: true },
      },
    },
    plugins: {
      'check-file': checkFile,
    },
    rules: {
      // Запрет мусорных имён файлов
      'check-file/filename-blocklist': [
        'error',
        {
          '**/{utils,helpers,lib,hooks,store,atoms}.{ts,tsx}': '',
        },
        {
          errorMessage:
            'Generic filename "{{ target }}" is not allowed — use a descriptive name instead (e.g. formatDate.ts, useProfileData.ts, profile.atoms.ts).',
        },
      ],
      // Компоненты (shared/entities/features/widgets/pages) — PascalCase.
      // Намеренно НЕ включает app/ и main.tsx — это фреймворковые
      // bootstrap-файлы (main.tsx, app/index.tsx, app/router.tsx), а не
      // переиспользуемые компоненты, поэтому конвенция на них не давит.
      // Хуки — camelCase.
      'check-file/filename-naming-convention': [
        'error',
        {
          'src/{shared,entities,features,widgets,pages}/**/*.tsx': 'PASCAL_CASE',
          'src/**/use*.ts': 'CAMEL_CASE',
        },
      ],
    },
  },
]
