import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import { NotificationLevels } from "discourse/lib/notification-levels";
import { i18n } from "discourse-i18n";

export default class CustomCategoryToggle extends Component {
  @service currentUser;

  @tracked isLoading = false;

  get category() {
    return this.args.outletArgs.category;
  }

  async setAllLevels(newLevel) {
    await this.category.setNotification(newLevel);

    if (this.category.subcategories && settings.include_subcategories) {
      let subcategories = this.category.subcategories.map((category) =>
        category.setNotification(newLevel)
      );
      await Promise.all(subcategories);
    }
  }

  get notificationLevel() {
    return this.category.get("notification_level");
  }

  get shouldShow() {
    return this.category && this.currentUser;
  }

  get isMuted() {
    return this.notificationLevel === NotificationLevels.MUTED;
  }

  get buttonTitle() {
    return this.isMuted
      ? i18n(themePrefix("custom_toggle.toggle_tracking"))
      : i18n(themePrefix("custom_toggle.toggle_mute"));
  }

  get iconName() {
    return this.isMuted ? settings.tracking_icon : settings.mute_icon;
  }

  @action
  async toggleMute() {
    this.isLoading = true;
    const newLevel = this.isMuted
      ? NotificationLevels.NORMAL
      : NotificationLevels.MUTED;

    try {
      await this.setAllLevels(newLevel);
    } finally {
      this.isLoading = false;
    }
  }

  <template>
    {{#if this.shouldShow}}
      <DButton
        class="btn-default custom-category-toggle"
        @translatedTitle={{this.buttonTitle}}
        @icon={{this.iconName}}
        @action={{this.toggleMute}}
        @isLoading={{this.isLoading}}
      />
    {{/if}}
  </template>
}
