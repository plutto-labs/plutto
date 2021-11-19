
<template>
  <Carousel
    :items-to-show="1"
    class="relative w-full text-primary"
  >
    <Slide
      v-for="slide in slides"
      :key="slide"
    >
      <div class="box-border flex flex-col items-center content-center px-8 mx-auto leading-6 border-0 border-gray-300 border-solid md:flex-row max-w-7xl lg:px-16">
        <div class="box-border w-full border-solid md:w-1/3 md:pl-6">
          <h2 class="m-0 text-xl font-semibold leading-tight text-left border-0 border-gray-300 lg:text-3xl md:text-2xl">
            {{ slide.title }}
          </h2>
          <p class="pt-4 pb-8 m-0 leading-7 text-left border-0 border-gray-300 sm:pr-10 lg:text-lg">
            {{ slide.subtitle }}
          </p>
          <ul class="p-0 m-0 leading-6 border-0 border-gray-300">
            <li
              class="box-border relative py-1 pl-0 text-left text-gray-500 border-solid"
              v-for="advantage in slide.advantages"
              :key="advantage"
            >
              <span class="inline-flex items-center justify-center w-6 h-6 mr-2 text-white rounded-full bg-melon"><span class="text-sm font-bold">✓</span></span>
              {{ advantage }}
            </li>
          </ul>
        </div>

        <div class="box-border relative flex-1 w-full max-w-md px-4 mt-10 mb-4 text-center bg-no-repeat bg-contain border-solid md:mt-0 md:max-w-none lg:mb-0 md:w-1/2">
          <img
            :src="require(`../../../../assets/images/${slide.image}`)"
            class="mt-1"
          >
        </div>
      </div>
    </Slide>

    <template #addons>
      <Navigation />
      <Pagination />
    </template>
  </Carousel>
</template>
<script>
import 'vue3-carousel/dist/carousel.css';
import { Carousel, Slide, Pagination, Navigation } from 'vue3-carousel';

export default {
  components: {
    Carousel, Slide, Pagination, Navigation,
  },
  data() {
    return {
      slides: [
        {
          title: '1. Customize your widget',
          subtitle: 'Build your own widget with your plans and style.',
          advantages: [
            'No code required',
            'Easy and flexible customization',
          ],
          image: 'landing-widget.png',
        },
        {
          title: '2. Deploy in 2 minutes',
          subtitle: 'Just copy and paste the code into your website.',
          advantages: [
            'Fast and simple',
            'One time integration',
          ],
          image: 'landing-code.png',
        },
        {
          title: 'Start receiving subscriptions',
          subtitle: 'Your users will be able to subscribe from the widget.',
          advantages: [
            'No extra code required',
            'Centralized management',
          ],
          image: 'landing-code.png',
        },
      ],
    };
  },
};
</script>
<style>
.carousel__next, .carousel__prev{
  @apply bg-primary mt-0 !important;
}

.carousel__next{
  @apply right-10 xl:right-0 !important;
}

.carousel__prev{
  @apply left-10 xl:left-0 !important;
}

.carousel__pagination-button{
  @apply bg-primary opacity-50 !important;
}

.carousel__pagination-button--active{
  @apply opacity-100 !important;
}

.carousel__pagination{
  @apply mt-0 !important;
}
</style>
