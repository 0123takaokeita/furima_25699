window.addEventListener("DOMContentLoaded", () => {
  // タグの入力欄を取得
  const tagNameInput = document.querySelector("#tag-name-form");
  // タグの入力欄がないなら実行せずここで終了
  if (!tagNameInput) return null;
  console.log("tag_search.js");

    tagNameInput.addEventListener("input", (e) => {
    const input = e.target.value;
    console.log("入力内容：", input);

    const xhr = new XMLHttpRequest();
    // params[:tag_name]に変数inputを送る
    xhr.open("GET", `/tags/?tag_name=${input}`, true);
    xhr.responseType = "json";
    xhr.send();
    xhr.onload = () => {
      // 非同期通信完了
      console.log("tag_result:", xhr.response.tags);
    };
  });
});