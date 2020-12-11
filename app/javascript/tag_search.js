
window.addEventListener("DOMContentLoaded", () => {
  // タグの入力欄を取得
  const tagNameInput = document.querySelector("#tag-name-form");
  // タグの入力欄がないなら実行せずここで終了
  if (!tagNameInput) return null;
  console.log("tag_search.js");

  tagNameInput.addEventListener("input", (e) => {
    const input = e.target.value;
    console.log("入力内容：", input);

    // 非同期通信開始
    const xhr = new XMLHttpRequest();
    // params[:tag_name]に変数inputを送る
    xhr.open("GET", `/tags/?tag_name=${input}`, true);
    xhr.responseType = "json";
    xhr.send();
    xhr.onload = () => {
      // 非同期通信完了
      console.log("tag_result:", xhr.response.tags);

      // ★★★追加ここから★★★

      const tags = xhr.response.tags;

      // 検索結果の親要素を取得する
      const tagSearchResultWrapper = document.querySelector(
        "#tag-search-result"
      );

      // 検索結果の親要素をリセットする
      tagSearchResultWrapper.innerHTML = "";
      tagSearchResultWrapper.setAttribute("style", "");

      if (tags.length != 0) {
        // 検索結果があるときのみ検索結果の親要素に枠線を表示させる
        tagSearchResultWrapper.setAttribute("style", "border: 1px solid black");
      }

      // 検索結果の親要素に検索結果を追加していく
      tags.forEach(function (tag) {
        // 検索結果要素の土台を用意する
        const tagElement = document.createElement("div");
        // 検索結果要素のテキストをタグのnameにする
        tagElement.innerText = tag.name;
        console.log('検索結果要素:', tagElement);
        // 検索結果要素の親に検索結果を挿入する
        tagSearchResultWrapper.appendChild(tagElement);
            // 検索結果要素にクリックイベントをaddする
        tagElement.addEventListener("click", () => {
          // 入力欄の値を検索結果要素のテキストに置き換える
          tagNameInput.value = tagElement.textContent;
          // 検索結果の親要素をリセットする
          tagSearchResultWrapper.setAttribute("style", "");
          tagSearchResultWrapper.innerHTML = "";
        });
      });


      // ★★★追加ここまで★★★
    };
  });
});