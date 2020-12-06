
window.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("charge-form");
  // カード登録用フォームがないならここで終了する
  if (!form) return false;

  console.log("create_token.js");

  const PAYJP_PK = process.env.PAYJP_PK;
  Payjp.setPublicKey(PAYJP_PK);

  form.addEventListener("submit", (e) => {
    e.preventDefault();
    const sendWithoutCardInfo = () => {
      document.getElementById("card-number").removeAttribute("name");
      document.getElementById("card-cvc").removeAttribute("name");
      document.getElementById("card-exp-month").removeAttribute("name");
      document.getElementById("card-exp-year").removeAttribute("name");
      document.getElementById("charge-form").submit();
      document.getElementById("charge-form").reset();
    };
    const formResult = document.getElementById("charge-form");
    const formData = new FormData(formResult);

    // カード情報の構成や、トークン生成はこちらのリファレンスを参照
    // https://pay.jp/docs/payjs-v1
    const card = {
      number: formData.get("number"),
      cvc: formData.get("cvc"),
      exp_month: formData.get("exp_month"),
      exp_year: `20${formData.get("exp_year")}`,
    };

    Payjp.createToken(card, (status, response) => {
      if (status === 200) {
        alert("カード登録に成功しました");
        // response.idでtokenが取得できます。
        const token = response.id;
        const renderDom = document.getElementById("charge-form");
        // サーバーにトークン情報を送信するために、inputタグをhidden状態で追加します。
        const tokenObj = `<input value=${token} type="hidden" name='token'>`;
        renderDom.insertAdjacentHTML("beforeend", tokenObj);
        sendWithoutCardInfo();
      } else {
        alert(`
        カード登録に失敗しました。
        エラー：${response.error.message}
        カード情報：
        {number: ${card.number} cvc: ${card.cvc} month: ${card.exp_month} year: ${card.exp_year}}
      `);
        sendWithoutCardInfo();
      }
    });
  });
});