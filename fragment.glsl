varying vec3 vPosition;
varying vec3 vNormal;
uniform float uTime;

void main(){
  // ストライプパターン
    float stripes = mod((vPosition.y - uTime * 0.02) * 20.0, 1.0);
    stripes = pow(stripes, 3.0);
  
  //fresnel：ビューベクトル（viewDirection）と法線ベクトル（vNormal）の間の関係を数値化
    vec3 viewDirection = normalize(vPosition - cameraPosition); 
    vec3 normal = normalize(vNormal);
  //背面の場合の調整
   if(!gl_FrontFacing) normal *= - 1.0;
  
   float fresnel = dot(viewDirection, normal) + 1.0;
   fresnel = (fresnel) / 2.0;
  
   fresnel = pow(fresnel, 2.0);

  // ストライプパターンとFresnel効果を組み合わせてる
    float holographic = stripes * fresnel;
    holographic += fresnel * 1.25;//Fresnel効果を強化
  
    // Falloffオブジェクトの輪郭が徐々に背景に溶け込むようなビジュアルを作り出す
   float falloff = smoothstep(0.8, 0.0, fresnel);
   holographic *= falloff;
  
  //  gl_FragColor = vec4(vPosition, 1.0);
  //  gl_FragColor = vec4(stripes, stripes, stripes, 1.0);
    gl_FragColor = vec4(0.5, 1.0, 1.0, holographic);
  
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}