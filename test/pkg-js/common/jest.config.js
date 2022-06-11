export default {
  preset: "es-jest",
  transform: {},
  collectCoverageFrom: ["src/**/*.js"],
  coverageDirectory: "artifacts/coverage/jest",
  watchman: false,
  haste: {
    enableSymlinks: true,
  },
};
