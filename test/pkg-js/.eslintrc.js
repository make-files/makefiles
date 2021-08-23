module.exports = {
  parserOptions: {
    ecmaVersion: 2019,
  },
  env: {
    jest: true,
    node: true,
  },
  rules: {
    'comma-dangle': ['error', 'always-multiline'],
    'no-console': 'warn',
  },
}
