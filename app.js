const STORAGE_PREFIX = "daily-entry:";
const launchView = document.getElementById("launchView");
const entryView = document.getElementById("entryView");
const beginButton = document.getElementById("beginButton");
const rustleToggle = document.getElementById("rustleToggle");
const dateInput = document.getElementById("entryDate");
const prettyDate = document.getElementById("prettyDate");
const dayOfYearLabel = document.getElementById("dayOfYear");
const saveStatus = document.getElementById("saveStatus");

const fieldIds = [
  "affirmation1",
  "affirmation2",
  "affirmation3",
  "mantra",
  "gratitude1",
  "gratitude2",
  "gratitude3",
];

function isoDate(date) {
  return date.toISOString().slice(0, 10);
}

function ordinal(value) {
  const mod100 = value % 100;
  if (mod100 >= 11 && mod100 <= 13) return `${value}th`;
  switch (value % 10) {
    case 1:
      return `${value}st`;
    case 2:
      return `${value}nd`;
    case 3:
      return `${value}rd`;
    default:
      return `${value}th`;
  }
}

function getDayOfYear(date) {
  const start = new Date(Date.UTC(date.getFullYear(), 0, 1));
  const current = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()));
  const diff = current - start;
  return Math.floor(diff / (1000 * 60 * 60 * 24)) + 1;
}

function formatDateLine(date) {
  const weekday = date.toLocaleDateString(undefined, { weekday: "long" });
  const month = date.toLocaleDateString(undefined, { month: "long" });
  return `${weekday} ${ordinal(date.getDate())} ${month} ${date.getFullYear()} ♡`;
}

function storageKey(dateValue) {
  return `${STORAGE_PREFIX}${dateValue}`;
}

function gatherState() {
  const state = {
    date: dateInput.value,
  };

  fieldIds.forEach((id) => {
    state[id] = document.getElementById(id).value;
  });

  return state;
}

function applyState(state) {
  fieldIds.forEach((id) => {
    document.getElementById(id).value = state?.[id] ?? "";
  });
}

function renderDateDerivedFields() {
  const selected = new Date(`${dateInput.value}T12:00:00`);
  prettyDate.textContent = formatDateLine(selected);
  dayOfYearLabel.textContent = `Day ${getDayOfYear(selected)}`;
}

function persistState() {
  const state = gatherState();
  localStorage.setItem(storageKey(dateInput.value), JSON.stringify(state));
  saveStatus.textContent = `Saved at ${new Date().toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" })}`;
}

function loadEntryForDate(dateValue) {
  const raw = localStorage.getItem(storageKey(dateValue));
  if (!raw) {
    applyState(null);
    saveStatus.textContent = "New page ready.";
    return;
  }

  try {
    applyState(JSON.parse(raw));
    saveStatus.textContent = "Resumed saved entry.";
  } catch {
    applyState(null);
    saveStatus.textContent = "Saved entry was unreadable; started a fresh page.";
  }
}

function playRustle() {
  if (!rustleToggle.checked || !(window.AudioContext || window.webkitAudioContext)) {
    return;
  }

  const Ctx = window.AudioContext || window.webkitAudioContext;
  const ctx = new Ctx();
  const noiseBuffer = ctx.createBuffer(1, ctx.sampleRate * 0.25, ctx.sampleRate);
  const output = noiseBuffer.getChannelData(0);
  for (let i = 0; i < output.length; i += 1) {
    output[i] = (Math.random() * 2 - 1) * (1 - i / output.length);
  }

  const source = ctx.createBufferSource();
  source.buffer = noiseBuffer;
  const filter = ctx.createBiquadFilter();
  filter.type = "bandpass";
  filter.frequency.value = 750;
  source.connect(filter);
  filter.connect(ctx.destination);
  source.start();
  source.stop(ctx.currentTime + 0.2);
}

function initialize() {
  const today = isoDate(new Date());
  dateInput.value = today;
  renderDateDerivedFields();
  loadEntryForDate(today);

  beginButton.addEventListener("click", () => {
    playRustle();
    launchView.classList.add("closing");
    window.setTimeout(() => {
      launchView.style.display = "none";
      entryView.classList.add("revealed");
    }, 350);
  });

  dateInput.addEventListener("change", () => {
    renderDateDerivedFields();
    loadEntryForDate(dateInput.value);
  });

  fieldIds.forEach((id) => {
    document.getElementById(id).addEventListener("input", persistState);
  });

  window.addEventListener("beforeunload", persistState);
}

initialize();
