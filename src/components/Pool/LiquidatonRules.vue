<template>
  <div class="liquid-rules-block">
    <div class="block-head">
      <p class="price-text">
        Liquidation price <span>${{ liquidationPrice }}</span>
      </p>
      <button class="safe-status" :class="{ medium: statusText === 'Medium' }">
        {{ statusText }}
      </button>
    </div>
    <div class="block-body">
      <div
        class="percent-item"
        :class="{ active: item == value, disabled: item > maxValue }"
        v-for="(item, idx) in percentItems"
        :key="idx"
        @click="setItemActive(item)"
      >
        <p>{{ item }}%</p>
      </div>
      <label
        class="percent-item custom"
        :class="{
          error: customErr,
          active: customValue == value && value !== '',
        }"
        @click="setCustomState(true)"
      >
        <input
          v-if="isCustom"
          v-model.trim="customValue"
          type="number"
          placeholder="XX%"
          @input="setCustomValue($event.target.value)"
        />
        <p v-else>custom</p>
      </label>
    </div>
  </div>
</template>

<script>
import { between } from "vuelidate/lib/validators";

export default {
  props: {
    reset: {
      type: Boolean,
    },
    liquidationPrice: {
      required: true,
    },
    maxValue: {
      type: Number,
      require: true,
    },
    value: {},
  },
  data() {
    return {
      percentItems: [25, 50, 70, 90],
      activePercent: null,
      isCustom: false,
      customValue: "",
      customErr: false,
    };
  },
  computed: {
    statusText() {
      if (this.value == this.maxValue) {
        return "Medium";
      } else {
        return "Safe";
      }
    },
  },
  watch: {
    reset(value) {
      if (value) this.resetData();
    },
  },
  validations: {
    customValue: {
      between: between(0, 100),
    },
  },
  methods: {
    resetData() {
      this.activePercent = null;
      this.isCustom = false;
      this.customValue = "";
    },
    setCustomValue(value) {
      this.customErr = false;
      if (value < 0 || value > this.maxValue) {
        this.customErr = true;
        this.emitValue("");
        return false;
      }

      if (value && value > 0 && value <= this.maxValue) this.emitValue(value);
      if (!value) this.emitValue("");
    },
    setCustomState(bool) {
      if (this.isCustom === bool) return false;
      this.isCustom = bool;
      if (bool) this.emitValue("");
    },
    setItemActive(item) {
      this.customErr = false;
      this.isCustom = false;
      this.customValue = "";
      this.emitValue(item);
    },
    emitValue(value) {
      if (!isNaN(value)) this.$emit("onchange", value);
    },
  },
};
</script>

<style lang="scss" scoped>
.liquid-rules-block {
  .block-head {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 18px;
  }

  .price-text {
    span {
      padding-left: 10px;
    }
  }

  .block-body {
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    overflow-x: auto;
  }

  .percent-item {
    background: rgba(255, 255, 255, 0.06);
    border-radius: 20px;
    height: 40px;
    padding: 0 20px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    border: 1px solid transparent;
    transition: border 0.3s ease;
    margin-right: 5px;

    &.custom {
      width: 140px;
      margin-right: 0;
    }

    input {
      background-color: transparent;
      border: none;
      height: 100%;
      text-align: center;
      color: #fff;
      outline: none;
      width: 100%;
      padding-left: 20px;
      padding-right: 20px;
    }

    &.disabled {
      pointer-events: none;
      color: grey;
    }

    &.active,
    &:hover {
      border: 1px solid #7b79f7;
    }

    &.error {
      border: 1px solid $clrInputError;
    }
  }

  .safe-status {
    min-width: 50px;
    height: 24px;
    outline: none;
    border: none;
    background: $clrBlue4;
    border-radius: 23px;
    font-size: 12px;
    color: $clrText;
    padding: 0 5px;
    transition: all 0.3s ease;

    &.medium {
      background: $clrOrange;
    }
  }
}
</style>
