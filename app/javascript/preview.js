
window.addEventListener("DOMContentLoaded", () => {
  // 商品出品・編集のフォームを取得
  const itemForm = document.querySelector('.items-sell-main');
  // 商品出品・編集のフォームがないなら実行せずここで終了
  if (!itemForm) return null;
  console.log('preview.js');


    // プレビュー画像を生成・表示する
    const buildPreviewImage = (dataIndex, blob) =>{
      // プレビュー画像の親要素を生成
      const previewWrapper = document.createElement('div');
      previewWrapper.setAttribute('class', 'preview');
  
      // プレビュー画像にdata-indexを設定
      previewWrapper.setAttribute('data-index', dataIndex);
  
      // プレビュー画像のimg要素を生成
      const previewImage = document.createElement('img');
      previewImage.setAttribute('src', blob);
      previewImage.setAttribute('class', 'preview-image');
  
      // プレビュー画像の親要素に子要素としてimg要素を追加する
      previewWrapper.appendChild(previewImage);
  
      console.log('プレビューの親要素:', previewWrapper);
      console.log('プレビューのimg要素:', previewImage);
  
      // プレビュー画像一覧にプレビュー画像を挿入する
      const previewsList = document.querySelector('#previews');
      previewsList.appendChild(previewWrapper);
    }
    
    // 画像用のfile_fieldを生成・表示する
  const buildNewFileField = () => {
    // 新しいfile_fieldを生成
    const newFileField = document.createElement('input');
    newFileField.setAttribute('type', 'file');
    newFileField.setAttribute('name', 'item[images][]');

    // ---file_fieldにdata-indexを設定ここから---
    // 最後のfile_fieldを取得
    const lastFileField = document.querySelector('input[type="file"][name="item[images][]"]:last-child')
    console.log('lastfilefield:',lastFileField);
    // nextDataIndex = 最後のfile_fieldのdata-index + 1
    const nextDataIndex = Number(lastFileField.getAttribute('data-index')) +1;
    console.log('next-data-index:', nextDataIndex);
    newFileField.setAttribute('data-index', nextDataIndex);
    // ---file_fieldにdata-indexを設定ここまで---

    // file_fieldにchangeイベントをセット
    newFileField.addEventListener("change", changedFileField);

    // file_fieldを追加
    const fileFieldsArea = document.querySelector('.click-upload');
    fileFieldsArea.appendChild(newFileField);
  };

    // 指定したdata-indexを持つプレビューとfile_fieldを削除する
    const deleteImage = (dataIndex) => {
      const previewWrapper = document.querySelector(
        `.preview[data-index="${dataIndex}"]`
      );
      previewWrapper.remove();
      const fileField = document.querySelector(
        `input[type="file"][data-index="${dataIndex}"]`
      );
      fileField.remove();
    };
  
  // 画像のfile_fieldの内容が変化（新しく選択、もしくは消える）したら発火するイベントで行われる処理
  const changedFileField = (e) => {
    console.log("changed:", e.target);
    console.table(e.target.files);
    console.log("1つ目のfile:", e.target.files[0]);

    // data-index（何番目を操作しているか）を取得
    const dataIndex = e.target.getAttribute("data-index");
    console.log("data-index:", dataIndex);


    const file = e.target.files[0];

        // fileが空 = 何も選択しなかったのでプレビュー等を削除して終了する
        if (!file) {
          deleteImage(dataIndex);
          return null;
        }

    // 選択されたファイルはblobという形式でブラウザが所持している
    const blob = window.URL.createObjectURL(file);
    console.log("blob:", blob);

        // data-indexを使って既にプレビューが表示されているかを確認する
        const oldPreviewWrapper = document.querySelector(
          `.preview[data-index="${dataIndex}"]`
        );
        if (oldPreviewWrapper) {
          // 既にプレビューが表示されているので画像の差し替えのみを行い終了する
          const oldPreviewImage = oldPreviewWrapper.querySelector("img");
          oldPreviewImage.setAttribute("src", blob);
          return null;
        }

        
    // dataIndexとblobを使ってプレビューを表示させる
    buildPreviewImage(dataIndex, blob);

    // 新しいfile_fieldを追加する
    buildNewFileField();
  };

   // 画像のfile_field
    const fileField = document.querySelector(
    'input[type="file"][name="item[images][]"]'
  );

  // 画像のfile_fieldの内容が変化（新しく選択、もしくは消える）したら発火するイベント
  fileField.addEventListener("change", changedFileField);
});