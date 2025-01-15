/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      screens: {
        'hd': { raw: '(width: 1280px) and (height: 720px)' },
        'hd_plus': { raw: '(width: 1366px) and (height: 768px)' },
        'fhd': { raw: '(width: 1920px) and (height: 1080px)' },
        'qhd': { raw: '(width: 2560px) and (height: 1440px)' },
        'uhd': { raw: '(width: 3840px) and (height: 2160px)' },

        'ultrawide_fhd': { raw: '(width: 2560px) and (height: 1080px)' }, 
        'ultrawide_qhd': { raw: '(width: 3440px) and (height: 1440px)' }, 
        'super_ultrawide': { raw: '(width: 5120px) and (height: 1440px)' }, 

        'aspect_4_3_1': { raw: '(width: 1280px) and (height: 960px)' }, 
        'aspect_4_3_2': { raw: '(width: 1600px) and (height: 1200px)' }, 
        'aspect_16_10': { raw: '(width: 1680px) and (height: 1050px)' }, 
      },
      keyframes: {
        'fade-slide-in': {
          '0%': { opacity: '0', transform: 'translateX(100%)' },
          '100%': { opacity: '1', transform: 'translateX(0)' },
        },
        'fade-slide-out': {
          '0%': { opacity: '1', transform: 'translateX(0)' },
          '100%': { opacity: '0', transform: 'translateX(100%)' },
        },
      },
      animation: {
        'fade-slide-in': 'fade-slide-in 0.5s ease-in-out',
        'fade-slide-out': 'fade-slide-out 0.5s ease-in-out',
      },
    },
  },
  plugins: [],
}