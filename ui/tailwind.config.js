module.exports = {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        background: '#1E1414',
        main: '#FACDB9',
        subduedText: '#645050',
        linkText: '#549EF5',
      },
      fontFamily: {
        'font-sans': ['Urbit Sans', 'sans-serif']
      },
    },
  },
  screens: {},
  variants: {
    extend: {
      typography: ({ theme }) => ({
        DEFAULT: {
          css: {
            '.geometric-titling-caps': {
              fontFeatureSettings: "'ss03' 1",
            },
          },
        },
      }),
    },
  },
  plugins: [
    require('@tailwindcss/typography')
  ],
};
