<template>
  <div class="plutto-loading">
    <span class="plutto-loading__indicator" />
  </div>
</template>

<style lang="scss" scoped>
.plutto-loading {
  @apply relative h-12;

  &__indicator {
    @apply absolute top-1/2 left-1/2 text-primary;
    height: 1em;
    width: 1em;
    border-radius: 50%;
    animation: loading 1.2s infinite linear;
    transform: translate(-50%, -50%);
    font-size: 6px;
  }
}

@keyframes loading {
  0%,
  100% {
    box-shadow: 0 -3em 0 .2em, 2em -2em 0 0, 3em 0 0 -1em, 2em 2em 0 -1em,
      0 3em 0 -1em, -2em 2em 0 -1em, -3em 0 0 -1em, -2em -2em 0 0;
  }

  12.5% {
    box-shadow: 0 -3em 0 0, 2em -2em 0 .2em, 3em 0 0 0, 2em 2em 0 -1em,
      0 3em 0 -1em, -2em 2em 0 -1em, -3em 0 0 -1em, -2em -2em 0 -1em;
  }

  25% {
    box-shadow: 0 -3em 0 -.5em, 2em -2em 0 0, 3em 0 0 .2em, 2em 2em 0 0,
      0 3em 0 -1em, -2em 2em 0 -1em, -3em 0 0 -1em, -2em -2em 0 -1em;
  }

  37.5% {
    box-shadow: 0 -3em 0 -1em, 2em -2em 0 -1em, 3em 0 0 0, 2em 2em 0 .2em,
      0 3em 0 0, -2em 2em 0 -1em, -3em 0 0 -1em, -2em -2em 0 -1em;
  }

  50% {
    box-shadow: 0 -3em 0 -1em, 2em -2em 0 -1em, 3em 0 0 -1em, 2em 2em 0 0,
      0 3em 0 .2em, -2em 2em 0 0, -3em 0 0 -1em, -2em -2em 0 -1em;
  }

  62.5% {
    box-shadow: 0 -3em 0 -1em, 2em -2em 0 -1em, 3em 0 0 -1em, 2em 2em 0 -1em,
      0 3em 0 0, -2em 2em 0 .2em, -3em 0 0 0, -2em -2em 0 -1em;
  }

  75% {
    box-shadow: 0 -3em 0 -1em, 2em -2em 0 -1em, 3em 0 0 -1em, 2em 2em 0 -1em,
      0 3em 0 -1em, -2em 2em 0 0, -3em 0 0 .2em, -2em -2em 0 0;
  }

  87.5% {
    box-shadow: 0 -3em 0 0, 2em -2em 0 -1em, 3em 0 0 -1em, 2em 2em 0 -1em,
      0 3em 0 -1em, -2em 2em 0 0, -3em 0 0 0, -2em -2em 0 .2em;
  }
}
</style>
