import { h } from "virtual-dom";
import { createWidget } from "discourse/widgets/widget";
import { iconNode } from "discourse-common/lib/icon-library";
import I18n from "discourse-i18n";

function setAllLevels(n, that) {
  that.attrs.category.setNotification(n);
  if (that.attrs.category.subcategories && settings.include_subcategories) {
    that.attrs.category.subcategories.forEach((category) =>
      category.setNotification(n)
    );
  }
}

createWidget("custom-category-track", {
  tagName: "button.btn.btn-default.custom-category-toggle.no-text.btn-icon",

  buildAttributes() {
    const attributes = {};
    if (this.attrs.category.notification_level === 0) {
      attributes.title = I18n.t(themePrefix("custom_toggle.toggle_tracking"));
    } else {
      attributes.title = I18n.t(themePrefix("custom_toggle.toggle_mute"));
    }
    return attributes;
  },

  html() {
    if (this.attrs.category.notification_level === 0) {
      return h("span", [
        iconNode(settings.tracking_icon),
        iconNode(settings.mute_icon),
      ]);
    } else {
      return h("span", [
        iconNode(settings.mute_icon),
        iconNode(settings.tracking_icon),
      ]);
    }
  },
  click() {
    this.sendWidgetAction("toggleMute");
  },
  toggleMute() {
    if (this.attrs.category.notification_level > 0) {
      setAllLevels(0, this);
    } else {
      setAllLevels(1, this);
    }
    this.scheduleRerender();
  },
});
