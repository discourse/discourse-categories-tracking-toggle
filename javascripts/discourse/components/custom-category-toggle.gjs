import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import { NotificationLevels } from "discourse/lib/notification-levels";
import I18n from "discourse-i18n";

export default class CustomCategoryToggle extends Component {
  @service currentUser;

  @tracked isLoading = false;

  category = this.args.outletArgs.category;

  async setAllLevels(newLevel) {
    await this.args.outletArgs.category.setNotification(newLevel);

    if (
      this.args.outletArgs.category.subcategories &&
      settings.include_subcategories
    ) {
      let subcategories = this.args.outletArgs.category.subcategories.map(
        (category) => category.setNotification(newLevel)
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
      ? I18n.t(themePrefix("custom_toggle.toggle_tracking"))
      : I18n.t(themePrefix("custom_toggle.toggle_mute"));
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
        class="btn btn-default custom-category-toggle no-text btn-icon"
        @translatedTitle={{this.buttonTitle}}
        @icon={{this.iconName}}
        @action={{this.toggleMute}}
        @isLoading={{this.isLoading}}
      />
    {{/if}}
  </template>
}
