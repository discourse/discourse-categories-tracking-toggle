import { apiInitializer } from "discourse/lib/api";
import CustomCategoryToggle from "../components/custom-category-toggle";

export default apiInitializer("1.14.0", (api) => {
  api.renderInOutlet("below-category-title-link", CustomCategoryToggle);
});
