import { apiInitializer } from "discourse/lib/api";
import CustomCategoryToggle from "../components/custom-category-toggle";

export default apiInitializer((api) => {
  api.renderInOutlet("below-category-title-link", CustomCategoryToggle);
});
