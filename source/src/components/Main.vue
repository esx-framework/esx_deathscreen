<script src="@/utils/Main.js">
</script>

<template>
  <div class="fixed bottom-0 left-0 right-0 flex flex-col items-center justify-end pointer-events-none space-y-4 pb-4">
    <Transition name="slide-up">
      <div
        v-if="showMessage.available"
        class="bg-[#161616] text-white text-center py-4 px-6 rounded-md shadow-lg pointer-events-auto"
      >
        <p class="text-lg poppins-medium">You are dead</p>
        <p class="text-sm mt-2">{{ messages.availableMessage }}</p>
      </div>
    </Transition>

    <Transition name="slide-up">
      <div
        v-if="showMessage.bleedout"
        class="bg-[#161616] text-white text-center py-4 px-6 rounded-md shadow-lg pointer-events-auto"
      >
        <p class="text-md poppins-medium">{{ messages.bleedoutMessage }}</p>
      </div>
    </Transition>
  </div>
</template>

<style>
</style>