varying vec3 vPosition;
varying vec3 vNormal;
uniform float uTime;

//ランダム値を生成
float random2D(vec2 value){
    return fract(sin(dot(value.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void main(){

    vec4 modelPosition = modelMatrix * vec4(position, 1.0);
   //モデルの頂点位置をランダムx軸とz軸に沿って移動、グリッチ効果を作る
   //モデルが静止していても頂点が動くようにuTime変数を使用
   // modelPosition.x += random2D(modelPosition.xz + uTime) - 0.5;
   // modelPosition.z += random2D(modelPosition.zx + uTime) - 0.5;
  
   //周期的にランダム変動を増減
    //float glitchStrength = sin(uTime);
   // float glitchStrength = sin(uTime - modelPosition.y);//uTime - modelPosition.yで下部から上部にかけて波のように移動
    
  //より複雑でランダムなエフェクトを実現するために、異なる周波数を持つ複数のsin関数の結果を合計して、正規化する
    float glitchTime = uTime - modelPosition.y;
    float glitchStrength = sin(glitchTime) + sin(glitchTime * 3.45) +  sin(glitchTime * 8.76);
    glitchStrength /= 3.0;
    glitchStrength = smoothstep(0.3, 1.0, glitchStrength);//エフェクトの出現頻度が減少
    glitchStrength *= 0.25;
  
  
    modelPosition.x += (random2D(modelPosition.xz + uTime) - 0.5) * glitchStrength;
    modelPosition.z += (random2D(modelPosition.zx + uTime) - 0.5) * glitchStrength;
  
    gl_Position = projectionMatrix * viewMatrix * modelPosition;
  
    //オブジェクトが変形しても正しい方向の法線ベクトルを送る
    vec4 modelNormal = modelMatrix * vec4(normal, 0.0);
    vNormal = modelNormal.xyz;

    vPosition = modelPosition.xyz;
      
}

//パターンの描画にはUV座標ではなく、modelPosition（ワールド座標）を使用する
//ワールド座標:オブジェクトが移動、回転、またはスケールしても、パターンはワールド空間内で静止して見えます
//position.xyzをvPositionに割り当てると、パターンも一緒に動きます