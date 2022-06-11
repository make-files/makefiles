import { dirname } from "path";
import { fileURLToPath } from "url";
import { StatsWriterPlugin } from "webpack-stats-plugin";
import { createConfig } from "../common/webpack.config.js";

export default createConfig(dirname(fileURLToPath(import.meta.url)), {
  StatsWriterPlugin,
});
