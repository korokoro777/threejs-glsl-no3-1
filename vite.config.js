import glsl from 'vite-plugin-glsl'
export default {
    base: '/threejs-glsl-no3-1/',
    build: {
      outDir: 'docs',
    },
    plugins: [glsl()]
}
