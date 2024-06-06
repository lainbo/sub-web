<template>
  <div id="app" class="parent-element">
    <div class="child-element">
    </div>
    <router-view/>
  </div>
</template>
<style scoped>
#app {
  min-height: 100vh;
  min-height: calc(var(--1dvh, 1vh) * 100);
  min-height: 100dvh;
  background-color: white;
}

.child-element {
  position: absolute;
  height: 100%;
  width: 100%;
  background-image: radial-gradient(#e5e7eb 1px, transparent 1px);
  background-size: 16px 16px;
  -webkit-mask-image: radial-gradient(ellipse 50% 50% at 50% 50%, black 70%, transparent 100%);
  mask-image: radial-gradient(ellipse 50% 50% at 50% 50%, black 70%, transparent 100%);
}
 
</style>
